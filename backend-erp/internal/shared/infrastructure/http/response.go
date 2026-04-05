package http

import "github.com/gofiber/fiber/v2"

type Response struct {
	Success bool        `json:"success"`
	Message string      `json:"message,omitempty"`
	Data    interface{} `json:"data,omitempty"`
	Error   string      `json:"error,omitempty"`
}

type Meta struct {
	Total int64 `json:"total"`
	Page  int   `json:"page"`
	Limit int   `json:"limit"`
	Pages int64 `json:"pages"`
}

func OK(c *fiber.Ctx, data interface{}) error {
	return c.Status(fiber.StatusOK).JSON(Response{Success: true, Data: data})
}

func Created(c *fiber.Ctx, data interface{}) error {
	return c.Status(fiber.StatusCreated).JSON(Response{Success: true, Data: data})
}

func OKMessage(c *fiber.Ctx, message string) error {
	return c.Status(fiber.StatusOK).JSON(Response{Success: true, Message: message})
}

func BadRequest(c *fiber.Ctx, err string) error {
	return c.Status(fiber.StatusBadRequest).JSON(Response{Success: false, Error: err})
}

func Unauthorized(c *fiber.Ctx, err string) error {
	return c.Status(fiber.StatusUnauthorized).JSON(Response{Success: false, Error: err})
}

func Forbidden(c *fiber.Ctx) error {
	return c.Status(fiber.StatusForbidden).JSON(Response{Success: false, Error: "forbidden"})
}

func NotFound(c *fiber.Ctx, err string) error {
	return c.Status(fiber.StatusNotFound).JSON(Response{Success: false, Error: err})
}

func Conflict(c *fiber.Ctx, err string) error {
	return c.Status(fiber.StatusConflict).JSON(Response{Success: false, Error: err})
}

func InternalError(c *fiber.Ctx) error {
	return c.Status(fiber.StatusInternalServerError).JSON(Response{Success: false, Error: "internal server error"})
}

func Pages(total int64, page, limit int) Meta {
	pages := total / int64(limit)
	if total%int64(limit) != 0 {
		pages++
	}
	return Meta{Total: total, Page: page, Limit: limit, Pages: pages}
}
