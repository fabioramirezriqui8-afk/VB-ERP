package domain

import (
	"errors"
	"fmt"
	"math"
	"regexp"
	"strings"
)

// ── Email ────────────────────────────────────────────────────────────────────

var emailRe = regexp.MustCompile(`^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$`)

type Email struct {
	value string
}

func NewEmail(raw string) (Email, error) {
	v := strings.ToLower(strings.TrimSpace(raw))
	if !emailRe.MatchString(v) {
		return Email{}, errors.New("invalid email format")
	}
	return Email{value: v}, nil
}

func (e Email) String() string { return e.value }

// ── Money ────────────────────────────────────────────────────────────────────

type Currency string

const (
	CurrencyUSD Currency = "USD"
	CurrencyMXN Currency = "MXN"
	CurrencyEUR Currency = "EUR"
)

// Money representa un valor monetario en centavos (sin float)
type Money struct {
	cents    int64
	currency Currency
}

func NewMoney(amount float64, currency Currency) (Money, error) {
	if amount < 0 {
		return Money{}, errors.New("money amount cannot be negative")
	}
	cents := int64(math.Round(amount * 100))
	return Money{cents: cents, currency: currency}, nil
}

func (m Money) Amount() float64    { return float64(m.cents) / 100 }
func (m Money) Currency() Currency { return m.currency }
func (m Money) Cents() int64       { return m.cents }

func (m Money) Add(other Money) (Money, error) {
	if m.currency != other.currency {
		return Money{}, fmt.Errorf("currency mismatch: %s vs %s", m.currency, other.currency)
	}
	return Money{cents: m.cents + other.cents, currency: m.currency}, nil
}

func (m Money) String() string {
	return fmt.Sprintf("%.2f %s", m.Amount(), m.currency)
}

// ── Quantity ─────────────────────────────────────────────────────────────────

type Quantity struct {
	value int
}

func NewQuantity(v int) (Quantity, error) {
	if v < 0 {
		return Quantity{}, errors.New("quantity cannot be negative")
	}
	return Quantity{value: v}, nil
}

func (q Quantity) Value() int { return q.value }

func (q Quantity) Subtract(other Quantity) (Quantity, error) {
	if q.value < other.value {
		return Quantity{}, errors.New("insufficient quantity")
	}
	return Quantity{value: q.value - other.value}, nil
}

func (q Quantity) Add(other Quantity) Quantity {
	return Quantity{value: q.value + other.value}
}
