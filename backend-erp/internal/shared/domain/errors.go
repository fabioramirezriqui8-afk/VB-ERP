package domain

import "fmt"

// DomainError representa un error de negocio con código y mensaje
type DomainError struct {
	Code    string
	Message string
}

func (e *DomainError) Error() string {
	return fmt.Sprintf("[%s] %s", e.Code, e.Message)
}

func NewDomainError(code, message string) *DomainError {
	return &DomainError{Code: code, Message: message}
}

// Errores comunes reutilizables por todos los módulos
var (
	ErrNotFound       = NewDomainError("NOT_FOUND", "resource not found")
	ErrAlreadyExists  = NewDomainError("ALREADY_EXISTS", "resource already exists")
	ErrUnauthorized   = NewDomainError("UNAUTHORIZED", "unauthorized")
	ErrForbidden      = NewDomainError("FORBIDDEN", "forbidden")
	ErrInvalidInput   = NewDomainError("INVALID_INPUT", "invalid input")
	ErrInternalServer = NewDomainError("INTERNAL_ERROR", "internal server error")
)

func NotFoundError(resource string) *DomainError {
	return NewDomainError("NOT_FOUND", fmt.Sprintf("%s not found", resource))
}

func AlreadyExistsError(resource string) *DomainError {
	return NewDomainError("ALREADY_EXISTS", fmt.Sprintf("%s already exists", resource))
}

func IsDomainError(err error) bool {
	_, ok := err.(*DomainError)
	return ok
}
