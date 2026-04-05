package domain

import (
	"github.com/google/uuid"
	sharedDomain "github.com/vctr/vb-erp/internal/shared/domain"
)

const (
	EventUserRegistered = "identity.user.registered"
	EventUserLoggedIn   = "identity.user.logged_in"
)

type UserRegisteredEvent struct {
	sharedDomain.BaseEvent
	UserName string
}

func NewUserRegisteredEvent(userID uuid.UUID, name string) UserRegisteredEvent {
	return UserRegisteredEvent{
		BaseEvent: sharedDomain.NewBaseEvent(EventUserRegistered, userID),
		UserName:  name,
	}
}
