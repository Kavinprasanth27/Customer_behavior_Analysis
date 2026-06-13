select * from customer_shopping;

use customer_behaviour;
#Q1.what is the total revenue by male vs female customers?

select gender,sum(purchase_amount) as revenue 
from customer_shopping
group by gender;

#Q2.which customers used a discount but sill spent more than the average purchase amount

select customer_id,purchase_amount
from customer_shopping
where discount_applied ='Yes' and purchase_amount >=(select avg(purchase_amount) from customer_shopping);

#Q3. which are the top 5 products with the highest average review rating?

select item_purchased, round(avg(review_rating),2) avg_product_rating
from customer_shopping
group by item_purchased
order by avg(review_rating) desc
limit 5;

#Q4.Compare the average purchase amounts between standard and express shipping.

select shipping_type, round(avg(purchase_amount),2)
from customer_shopping
where shipping_type in ('Standard','Express')
group by shipping_type;

#Q5:Do subscribed customers spend more? Compare average spend and total revenue between subscribers and non-subscribers

select subscription_status,
count(customer_id) as customer_count,
round(avg(purchase_amount),2) as avg_spend,
round(sum(purchase_amount),2) as total_revenue
from customer_shopping
group by subscription_status
order by total_revenue,avg_spend desc;

#Q6: which 5 products have the highest percentage of purchases with discounts applied?

select item_purchased,
round(sum(case when discount_applied='Yes' then 1 else 0 end)/count(*)*100,2) as discount_rate
from customer_shopping
group by item_purchased
order by discount_rate desc
limit 5 ;

#Q7:Segment customers into new,returning, and loyal based on their total number of previous purchases , and show the count of each segment

with customer_type as (
select customer_id,previous_purchases,
case
	when previous_purchases =1 then 'new'
    when previous_purchases between 1 and 10 then 'returning'
    else 'loyal'
    end as customer_segment
from customer_shopping)

select customer_segment,count(*) as 'number of customers'
from customer_type
group by customer_segment ;

#Q8: what are the top 3 most purchased products within each category

with item_count as (
select category,
item_purchased,
count(customer_id) as total_orders,
row_number() over (partition by category order by count(customer_id) desc) as item_rank 
from customer_shopping
group by category,item_purchased)

select item_rank,item_purchased,category,total_orders
from item_count
where item_rank <=3;

#Q9:Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?

select subscription_status,count(customer_id) as repeat_buyers
from customer_shopping
where previous_purchases >=5
group by subscription_status;

#Q10:what are the revenue contribution of each age group?

select age_group,sum(purchase_amount) as total_revenue 
from customer_shopping
group by age_group
order by total_revenue desc;







