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
		return c.JSON(http.StatusBadRequest, err)
	}

	return c.JSON(http.StatusOK, "Database up migrated")
}

func (h *Handler) DownDB(c echo.Context) error {
	var req Request
	if err := c.Bind(&req); err != nil {
		return c.JSON(http.StatusBadRequest, err)
	}

	if len(req.Migrations) <= 0 {
		return c.JSON(http.StatusBadRequest, errors.New("invalid request bad request"))
	}

	initDefault()
	err := h.service.Down(&req, filePath)
	if err != nil {
		return c.JSON(http.StatusBadRequest, err)
	}

	return c.JSON(http.StatusOK, "Database down migrated")
}

func initDefault() {
	migrations = []Migrations{
		{
			Type: "schema_shared",
		},
		{
			Type: "schema_content",
		},
		{
			Type: "schema_identity",
		},
		{
			Type: "schema_actor",
		},
		{
			Type: "schema_media",
		},
		{
			Type: "schema_attempts",
		},
		{
			Type: "schema_streaks",
		},
		{
			Type: "schema_quests",
		},
		{
			Type: "schema_achievements",
		},
		{
			Type: "schema_stats",
		},
		{
			Type: "schema_leaderboard",
		},
		{
			Type: "schema_social",
		},
		{
			Type: "schema_economy",
		},
		{
			Type: "schema_items",
		},
		{
			Type: "schema_buffs",
		},
		{
			Type: "schema_analytics",
		},
		{
			Type: "data",
		},
	}
	filePath = map[string]string{
		"schema_shared":     "file://migration/schema_shared",
		"schema_content":    "file://migration/schema_content",
		"schema_identity":   "file://migration/schema_identity",
		"schema_actor":      "file://migration/schema_actor",
		"schema_media":      "file://migration/schema_media",
		"schema_attempts":   "file://migration/schema_attempts",
		"schema_streaks":    "file://migration/schema_streaks",
		"schema_quests":     "file://migration/schema_quests",
		"schema_achievements":"file://migration/schema_achievements",
		"schema_stats":      "file://migration/schema_stats",
		"schema_leaderboard":"file://migration/schema_leaderboard",
		"schema_social":     "file://migration/schema_social",
		"schema_economy":    "file://migration/schema_economy",
		"schema_items":      "file://migration/schema_items",
		"schema_buffs":      "file://migration/schema_buffs",
		"schema_analytics":  "file://migration/schema_analytics",
		"data":   "file://migration/data",
	}
}
