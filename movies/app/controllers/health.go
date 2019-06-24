package controllers

import (
	"github.com/revel/revel"
)

type Health struct {
	*revel.Controller
}

func (c Health) Index() revel.Result {
	return c.RenderJSON("Ok")
}
