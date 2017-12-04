require "aws-sdk"

Aws.config.update({
                    region: "us-west-2",
                    endpoint: "http://localhost:8000",
                    access_key_id: 'AKIAIQA5DNVFHSW4YAZA',
                    secret_access_key: '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'
                  })

dynamodb = Aws::DynamoDB::Client.new

params = {
  table_name: "Movies",
  key_schema: [
    {
      attribute_name: "year",
      key_type: "HASH"  #Partition key
    },
    {
      attribute_name: "title",
      key_type: "RANGE" #Sort key
    }
  ],
  attribute_definitions: [
    {
      attribute_name: "year",
      attribute_type: "N"
    },
    {
      attribute_name: "title",
      attribute_type: "S"
    },

  ],
  provisioned_throughput: {
    read_capacity_units: 10,
    write_capacity_units: 10
  }
}

begin
  result = dynamodb.create_table(params)
  puts "Created table. Status: " +
         result.table_description.table_status;

rescue  Aws::DynamoDB::Errors::ServiceError => error
  puts "Unable to create table:"
  puts "#{error.message}"
end
