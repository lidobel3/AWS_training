terraform {
    cloud {
        organization = "Belcorp"
        workspaces {
            name = "Dev"
        }
    }
}

# credentials "app.terraform.io" {
#     token = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Ik1VRTNPRFE0UkVGRU1ESXhRemczT0VFNU5UazROalJHT0RnME5qSTRNRGc1TjBNeVJqVXlSUSJ9.eyJpc3MiOiJodHRwczovL2F1dGguaGFzaGljb3JwLmNvbS8iLCJzdWIiOiI4bnk2MXJVTUttZW9PazZqT0JrRzlpWVRKQzBKRDdjQUBjbGllbnRzIiwiYXVkIjoiaHR0cHM6Ly9hcGkuaGFzaGljb3JwLmNsb3VkIiwiaWF0IjoxNzYyMDA3NTYzLCJleHAiOjE3NjIwMTExNjMsImd0eSI6ImNsaWVudC1jcmVkZW50aWFscyIsImF6cCI6IjhueTYxclVNS21lb09rNmpPQmtHOWlZVEpDMEpEN2NBIn0.K7iXgJ2FVto0nEsRDZkmrkJfjpVlEBUr_I7toJQteHtY74nl1XlFIoaeyf_4zmCNZi95UXZ2eBsV_qfMkG8zLJv_uVV9FXpHB2dyBKvZutLOD_t42SmRvJz_lDGh-RvO-BXkmedt_-0tl3Dx8VFbFz2IUSwfwDhg_1F02IQFO3eaZ_4lYog45HUO6Q9K6lvVhOC0torDQFBi9YFHRA6FYQcKfYsZa1TjQblapp_gJqpZxb_ko7EG68jajsF6UkgRzDdQYHI6Ee3tjKQu0MLLDy2n15HNHQ-pe6W2US3jCixmrK8er5IGRIdNplhwZljuRBJERmb5eB6T6_YinomgXg"
# }