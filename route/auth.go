package route

import (
	"log"
	"net/http"

	"github.com/aleksraiden/fabio/auth"
)

func (t *Target) Authorized(r *http.Request, w http.ResponseWriter, authSchemes map[string]auth.AuthScheme) bool {
	if t.AuthScheme == "" {
		return true
	}

	scheme := authSchemes[t.AuthScheme]

	if scheme == nil {
		log.Printf("[ERROR] unknown auth scheme '%s'\n", t.AuthScheme)
		return false
	}

	return scheme.Authorized(r, w)
}
