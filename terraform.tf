terraform {
    cloud {
        organization = "Belcorp"

        workspaces {
            name = "Dev"
        }
    }
}