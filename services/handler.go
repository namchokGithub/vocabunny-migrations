package services

import (
	"errors"
	"net/http"

	"github.com/labstack/echo/v4"
)

type Servicer interface {
	Up(req *Request, filePath map[string]string) error
	Down(req *Request, filePath map[string]string) error
}

type Handler struct {
	service Servicer
}

func NewHandler(service Servicer) *Handler {
	return &Handler{
		service: service,
	}
}

var filePath map[string]string
var migrations []Migrations

func (h *Handler) UpDB(c echo.Context) error {
	var req Request
	if err := c.Bind(&req); err != nil {
		return c.JSON(http.StatusBadRequest, "invalid request")
	}

	initDefault()
	if req.Migrations == nil {
		req.Migrations = migrations
	}

	err := h.service.Up(&req, filePath)
	if err != nil {
		return c.JSON(http.StatusBadRequest, err.Error())
	}

	return c.JSON(http.StatusOK, "Database up migrated")
}

func (h *Handler) DownDB(c echo.Context) error {
	var req Request
	if err := c.Bind(&req); err != nil {
		return c.JSON(http.StatusBadRequest, err.Error())
	}

	if len(req.Migrations) <= 0 {
		return c.JSON(http.StatusBadRequest, errors.New("invalid request bad request").Error())
	}

	initDefault()
	err := h.service.Down(&req, filePath)
	if err != nil {
		return c.JSON(http.StatusBadRequest, err.Error())
	}

	return c.JSON(http.StatusOK, "Database down migrated")
}

func initDefault() {
	migrations = []Migrations{
		{
			Type: "schema",
		},
	}
	filePath = map[string]string{
		"schema": "file://migration/schema",
	}
}
