SELECT
  Customerid AS CustomerId,
  {{ name_formatter("split_part(Name, ' ', 1)") }} AS FirstName,
  {{ name_formatter("split_part(Name, ' ', 2)") }} AS LastName,
  {{ phone_number_formatter('Phone') }} AS PhoneNumber,
  Email AS EmailAddress,
  Address AS Address,
  Region AS Region,
  PostalZip AS PostalZip,
  Country  AS Country
FROM {{ source('raw', 'customers') }}
