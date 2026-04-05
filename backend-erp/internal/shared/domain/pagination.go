package domain

// PageRequest parámetros de paginación para cualquier query
type PageRequest struct {
	Page  int
	Limit int
}

func (p PageRequest) Offset() int {
	if p.Page < 1 {
		p.Page = 1
	}
	return (p.Page - 1) * p.Limit
}

func (p *PageRequest) Normalize() {
	if p.Page < 1 {
		p.Page = 1
	}
	if p.Limit < 1 || p.Limit > 100 {
		p.Limit = 20
	}
}

// PageResult respuesta paginada genérica
type PageResult[T any] struct {
	Items      []T   `json:"items"`
	Total      int64 `json:"total"`
	Page       int   `json:"page"`
	Limit      int   `json:"limit"`
	TotalPages int64 `json:"total_pages"`
}

func NewPageResult[T any](items []T, total int64, req PageRequest) PageResult[T] {
	pages := total / int64(req.Limit)
	if total%int64(req.Limit) != 0 {
		pages++
	}
	return PageResult[T]{
		Items:      items,
		Total:      total,
		Page:       req.Page,
		Limit:      req.Limit,
		TotalPages: pages,
	}
}

// Result es un tipo genérico que representa éxito o fallo
type Result[T any] struct {
	value T
	err   error
}

func Ok[T any](value T) Result[T]   { return Result[T]{value: value} }
func Fail[T any](err error) Result[T] { return Result[T]{err: err} }

func (r Result[T]) IsOk() bool   { return r.err == nil }
func (r Result[T]) IsFail() bool { return r.err != nil }
func (r Result[T]) Value() T     { return r.value }
func (r Result[T]) Err() error   { return r.err }

func (r Result[T]) Unwrap() T {
	if r.err != nil {
		panic(r.err)
	}
	return r.value
}
