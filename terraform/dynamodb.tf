resource "aws_dynamodb_table" "AuctionsTable" {
    attribute {
        name = "Aim"
        type = "S"
    }
    attribute {
        name = "Category"
        type = "S"
    }
    attribute {
        name = "Id"
        type = "S"
    }
    attribute {
        name = "Name"
        type = "S"
    }
    name = "Auctions"
    hash_key = "Aim"
    range_key = "Id"
    read_capacity = 1
    write_capacity = 1
    local_secondary_index {
        name = "ByNameIndex"
        range_key = "Name"
        projection_type = "ALL"
    }
    local_secondary_index {
        name = "ByCategoryIndex"
        range_key = "Category"
        projection_type = "ALL"
    }
    global_secondary_index {
        name = "ById"
        hash_key = "Id"
        projection_type = "ALL"
        read_capacity = 1
        write_capacity = 1
    }
}

resource "aws_dynamodb_table" "AimTable" {
    attribute {
        name = "AimId"
        type = "S"
    }
    name = "Aims"
    hash_key = "AimId"
    read_capacity = 5
    write_capacity = 5
}