select 
    id as product_id,
    name as product_name,
    cateogry as product_category, 
    price as product_price
from
    {{ source('raw_data', 'products') }}