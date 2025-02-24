---
title: "registry.consul.pollinterval"
---

	
`registry.consul.pollinterval` configures the poll interval
for route updates. If Poll interval is set to 0 the updates will
be disabled and fall back to blocking queries.  Other values can
be any time definition. e.g. `1s, 100ms`


The default is

    registry.consul.pollinterval = 0
