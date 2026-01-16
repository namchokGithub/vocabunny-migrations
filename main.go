package main

import (
	"context"
	"database/sql"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"runtime"
	"syscall"

	"github.com/joho/godotenv"

	_ "github.com/golang-migrate/migrate/v4/source/file"
	"github.com/labstack/echo/v4"
	_ "github.com/lib/pq"
	"gitlab.socket9.com/brandname-hunter/order-management-db-migrations/pkg/logx"
	"gitlab.socket9.com/brandname-hunter/order-management-db-migrations/services"
)

func init() {
	runtime.GOMAXPROCS(1)

	logx.Init("serve-rest", "trace")

	envFilePath := os.Getenv("ENV_FILE_PATH")
	if envFilePath == "" {
		envFilePath = ".env"
	}

	isServer := os.Getenv("IS_ON_SERVER")
	if isServer == "false" || isServer == "" {
		err := godotenv.Load(envFilePath)
		if err != nil {
			panic("Error loading .env file")
		}
	}
}

func main() {
	var (
		e = initEcho()
	)

	dbT, err := initDB()
	if err != nil {
		logx.GetLog().Infof("could not connect to the database... %v", err)
		return
	}

	ht := services.NewHandler(services.NewService(dbT))

	e.POST("/up", ht.UpDB)
	e.POST("/down", ht.DownDB)

	e.GET("/health", makeHealthHandler(dbT))

	logx.GetLog().Info("Listening on port: ", os.Getenv("PORT"))
	go func() {
		logx.GetLog().Info(e.Start(":" + os.Getenv("PORT")))
	}()

	gracefulShutdown(e)
}

func initEcho() *echo.Echo {
	e := echo.New()
	e.HideBanner = true
	e.HidePort = true

	return e
}

func initDB() (*sql.DB, error) {
	psqlInfo := fmt.Sprintf("host=%s port=%s user=%s password='%s' dbname=%s sslmode=disable",
		os.Getenv("POSTGRES_HOST"),
		os.Getenv("POSTGRES_PORT"),
		os.Getenv("POSTGRES_USER"),
		os.Getenv("POSTGRES_PASS"),
		os.Getenv("POSTGRES_DATABASE"))

	db, err := sql.Open("postgres", psqlInfo)
	if err != nil {
		logx.GetLog().Errorf("postgres DB... err : %v", err.Error())
		return nil, err
	}

	err = db.Ping()
	if err != nil {
		logx.GetLog().Infof("could not ping DB... %v", err)
		return nil, err
	}

	fmt.Println("Successfully connected!")

	return db, nil
}

func gracefulShutdown(e *echo.Echo) {
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, os.Interrupt, syscall.SIGTERM)

	<-quit

	if err := e.Shutdown(context.Background()); err != nil {
		logx.GetLog().Infof("shutdown server: %s", err)
	}
}

func makeHealthHandler(db *sql.DB) echo.HandlerFunc {
	return func(c echo.Context) error {
		err := db.Ping()
		if err != nil {
			logx.GetLog().Error("db ping error: ", err)
			return c.JSON(http.StatusInternalServerError, map[string]string{
				"status": "unhealthy",
				"msg":    fmt.Sprintf("db ping error: %s", err.Error()),
			})
		}
		return c.JSON(http.StatusOK, map[string]string{"status": "healthy"})
	}
}
