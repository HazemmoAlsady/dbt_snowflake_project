
  create or replace   view finance_db.raw.stg_products
  
  
  
  
  as (
    select 
    id as product_id,
    name as product_name,
    cateogry as product_category, 
    price as product_price
from
    finance_db.raw.products
  );

