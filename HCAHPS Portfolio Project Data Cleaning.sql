select * from hospital_data.hcahps_data
select * from hospital_data.hospital_beds

/* Data cleaning Project:

For hospital_bed table:
- Ensure provider_ccn is 6 digits, in case of leading 0 (ex: 56564 -> 056564)
- Change fiscal_year_begin_date and fiscal_year_end_date into date data type from string
- Ensure all data is u-to-date by removing hospitals with older data
*/

with hospital_beds_prep as 
(
	select lpad(provider_ccn::text, 6,'0') as provider_ccn
		, hospital_name
		, to_date(fiscal_year_begin_date,'MM/DD/YYYY') as fiscal_year_begin_date
		, to_date(fiscal_year_end_date,'MM/DD/YYYY') as fiscal_year_end_date
		, number_of_beds
		, row_number() over(partition by provider_ccn order by to_date(fiscal_year_end_date,'MM/DD/YYYY') desc ) as nth_row
	from hospital_data.hospital_beds
)
select *
from hospital_beds_prep
where nth_row = 1


/* 
For hcahps_data table:
- Ensure facility_id is 6 digits, in case of leading 0 (ex: 56564 -> 056564)
- Change start_date and end_date into date data type from string
*/

select lpad(facility_id::text, 6,'0') as facility_id
	, to_date(start_date,'MM/DD/YYYY') as start_date
	, to_date(end_date,'MM/DD/YYYY') as end_date
	,
from hospital_data.hcahps_data


-- Join Together:
	
with hospital_beds_prep as 
(
	select lpad(provider_ccn::text, 6,'0') as provider_ccn
		, hospital_name
		, to_date(fiscal_year_begin_date,'MM/DD/YYYY') as fiscal_year_begin_date
		, to_date(fiscal_year_end_date,'MM/DD/YYYY') as fiscal_year_end_date
		, number_of_beds
		, row_number() over(partition by provider_ccn order by to_date(fiscal_year_end_date,'MM/DD/YYYY') desc ) as nth_row
	from hospital_data.hospital_beds
)
select lpad(facility_id::text, 6,'0') as facility_id
	, to_date(start_date,'MM/DD/YYYY') as start_date_converted
	, to_date(end_date,'MM/DD/YYYY') as end_date_converted
	, hcahps.*
	, bed.number_of_beds
	, bed.fiscal_year_begin_date as beds_start_period
	, bed.fiscal_year_end_date as beds_end_period
from hospital_data.hcahps_data hcahps
left join hospital_beds_prep bed on lpad(facility_id::text, 6,'0') = bed.provider_ccn
and bed.nth_row = 1


