package domain

import "context"

// UnitOfWork garantiza que múltiples operaciones se ejecuten en una sola transacción
type UnitOfWork interface {
	Begin(ctx context.Context) (context.Context, error)
	Commit(ctx context.Context) error
	Rollback(ctx context.Context) error
}

// WithTransaction ejecuta fn dentro de una transacción con rollback automático
func WithTransaction(ctx context.Context, uow UnitOfWork, fn func(ctx context.Context) error) error {
	txCtx, err := uow.Begin(ctx)
	if err != nil {
		return err
	}
	if err := fn(txCtx); err != nil {
		_ = uow.Rollback(txCtx)
		return err
	}
	return uow.Commit(txCtx)
}
