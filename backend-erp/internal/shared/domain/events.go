package domain

import (
	"time"

	"github.com/google/uuid"
)

// DomainEvent es la interfaz base para todos los eventos de dominio
type DomainEvent interface {
	EventID() uuid.UUID
	EventName() string
	OccurredAt() time.Time
	AggregateID() uuid.UUID
}

// BaseEvent implementa los campos comunes de todo evento
type BaseEvent struct {
	id          uuid.UUID
	name        string
	occurredAt  time.Time
	aggregateID uuid.UUID
}

func NewBaseEvent(name string, aggregateID uuid.UUID) BaseEvent {
	return BaseEvent{
		id:          uuid.New(),
		name:        name,
		occurredAt:  time.Now(),
		aggregateID: aggregateID,
	}
}

func (e BaseEvent) EventID() uuid.UUID     { return e.id }
func (e BaseEvent) EventName() string      { return e.name }
func (e BaseEvent) OccurredAt() time.Time  { return e.occurredAt }
func (e BaseEvent) AggregateID() uuid.UUID { return e.aggregateID }

// EventDispatcher contrato para publicar eventos de dominio
type EventDispatcher interface {
	Dispatch(events ...DomainEvent) error
}

// AggregateRoot base para todos los agregados — acumula eventos pendientes
type AggregateRoot struct {
	events []DomainEvent
}

func (a *AggregateRoot) AddEvent(e DomainEvent) {
	a.events = append(a.events, e)
}

func (a *AggregateRoot) PullEvents() []DomainEvent {
	evts := a.events
	a.events = nil
	return evts
}
