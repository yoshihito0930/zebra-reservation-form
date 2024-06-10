# IAM User
resource "aws_iam_user" "admin" {
    force_destroy = "false"
    name          = var.admin-user
    path          = "/"

    tags = {
        AKIA3X6SIRR5IHDVPPWJ = "github actions"
        AKIA3X6SIRR5KQ677P5E = "wsl"
    }

    tags_all = {
        AKIA3X6SIRR5IHDVPPWJ = "github actions"
        AKIA3X6SIRR5KQ677P5E = "wsl"
    }
}

resource "aws_iam_access_key" "admin-key1" {
    user       = aws_iam_user.admin.name
    status     = "Active"
}

resource "aws_iam_access_key" "admin-key2" {
    user       = aws_iam_user.admin.name
    status     = "Active"
}


resource "aws_iam_user" "github-s3" {
    force_destroy = "false"
    name          = var.githubAction-user
    path          = "/"

    tags = {
        AKIA3X6SIRR5JIEQYVVF = "for github access_key"
    }

    tags_all = {
        AKIA3X6SIRR5JIEQYVVF = "for github access_key"
    }
}

resource "aws_iam_access_key" "github-s3-key1" {
    user       = aws_iam_user.github-s3.name
    status     = "Active"
}

# IAM Groupe
resource "aws_iam_group" "administrator" {
    name = "administrator"
    path = "/"
}

resource "aws_iam_group_policy_attachment" "AdministratorAccess" {
    group      = aws_iam_group.administrator.name
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# IAM Role

# IAM Policy
