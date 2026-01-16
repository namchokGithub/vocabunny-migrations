package services

import (
	"database/sql"
	"errors"
	"sort"
	"strconv"

	"github.com/golang-migrate/migrate/v4"
	migrateSQL "github.com/golang-migrate/migrate/v4/database/postgres"
	_ "github.com/golang-migrate/migrate/v4/source/file"

	"gitlab.socket9.com/brandname-hunter/order-management-db-migrations/pkg/logx"
)

type Service struct {
	db *sql.DB
}

func NewService(db *sql.DB) *Service {
	return &Service{
		db: db,
	}
}

var (
	dataMigrations = "data_migrations"

	typeSortMapUp = map[string]int{
		"schema": 1,
		"data":   2,
	}

	typeSortMapDown = map[string]int{
		"schema": 2,
		"data":   1,
	}

	dataConfig = map[string]*migrateSQL.Config{
		"schema": {
			MigrationsTable: migrateSQL.DefaultMigrationsTable,
		},
		"data": {
			MigrationsTable: dataMigrations,
		},
	}
)

func (s *Service) Up(req *Request, filePath map[string]string) error {
	sortRequestUp(req)
	for _, migration := range req.Migrations {
		_type := migration.Type
		logx.GetLog().Infof("Migrated Type : %s", _type)
		driver, err := migrateSQL.WithInstance(s.db, dataConfig[_type])
		if err != nil {
			logx.GetLog().Errorf("could not start sql migration... %v", err)
			return err
		}

		file := filePath[_type]
		logx.GetLog().Infof("Migrated file path : %s", file)
		m, err := migrate.NewWithDatabaseInstance(file, "mysql", driver)
		if err != nil {
			logx.GetLog().Errorf("migration failed... %v", err)
			return err
		}

		forceVersion := migration.ForceVersion
		if forceVersion > 0 {
			m.Force(forceVersion)
			logx.GetLog().Infof("forced to migration version %d", forceVersion)
		}

		if err := m.Up(); err != nil && err != migrate.ErrNoChange {
			logx.GetLog().Errorf("An error occurred while syncing the database.. %v", err)
			curVersion, _, _ := m.Version()
			return errors.New("Migrated Type : " + _type + "Error Version : " + strconv.Itoa(int(curVersion)) + " " + err.Error())
		}

		logx.GetLog().Infof("Database up migrated (type:%v)", _type)
	}

	return nil
}

func (s *Service) Down(req *Request, filePath map[string]string) error {
	sortRequestDown(req)
	for _, migration := range req.Migrations {
		_type := migration.Type
		logx.GetLog().Infof("Migrated Type : %s", _type)
		driver, err := migrateSQL.WithInstance(s.db, dataConfig[_type])
		if err != nil {
			logx.GetLog().Errorf("could not start sql migration... %v", err)
			return err
		}

		file := filePath[_type]
		logx.GetLog().Infof("Migrated file path : %s", file)
		m, err := migrate.NewWithDatabaseInstance(file, "mysql", driver)
		if err != nil {
			logx.GetLog().Errorf("migration failed... %v", err)
			return err
		}

		curVersion, _, _ := m.Version()
		forceVersion := (int(curVersion) - migration.ForceVersion) * -1

		if err := m.Steps(forceVersion); err != nil && err != migrate.ErrNoChange {
			logx.GetLog().Errorf("An error occurred while syncing the database.. %v", err)
			curVersion, _, _ := m.Version()
			return errors.New("Migrated Type : " + _type + "Error Version : " + strconv.Itoa(int(curVersion)) + " " + err.Error())
		}

		logx.GetLog().Infof("Database Down migrated (type:%v)", _type)
	}

	return nil
}

func sortRequestUp(req *Request) {
	sort.SliceStable(req.Migrations, func(i, j int) bool {
		typeI := req.Migrations[i].Type
		typeJ := req.Migrations[j].Type
		if typeSortMapUp[typeI] < typeSortMapUp[typeJ] {
			return true
		}
		return false
	})
}

func sortRequestDown(req *Request) {
	sort.SliceStable(req.Migrations, func(i, j int) bool {
		typeI := req.Migrations[i].Type
		typeJ := req.Migrations[j].Type
		if typeSortMapDown[typeI] < typeSortMapDown[typeJ] {
			return true
		}
		return false
	})
}
