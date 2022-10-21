select * from Data1;

update data1 set Growth = replace(Growth,'%','');
alter table data1 alter column Growth float;
alter table data1 alter column Literacy float;

select * from data2;
delete from Data2 where State = '#N/A';


 -- lets see info of jalgaon
select * from data1 as d1 inner join data2 as d2 on d1.District = d2.District 
where d2.State = 'Maharashtra' and d2.District = 'Jalgaon' ;



-- Total Population of Maharashtra
select sum(Population) as 'Total Population' from data2
where state = 'Maharashtra';


-- Average Growth for India
select concat( round(avg(Growth),2) , ' %') as 'Average Growth' from data1;

-- Average growth State wise
select State,concat( round(avg(Growth),2) , ' %') as 'Average Growth' from data1
group by State order by avg(Growth) desc;



-- Overall Average Literacy
select concat( round(avg(Literacy),2) , ' %') as 'Average Literacy' from data1;



-- Avg literacy State wise
select State,concat( round(avg(Literacy),2) , ' %') as 'Average Literacy' from data1
group by State order by avg(Literacy) desc;



-- top 3 States with Lowest literacy
select top 3 State,concat( round(avg(Literacy),2) , ' %') as 'Lowest literacy' from data1
group by State order by avg(Literacy);



-- top 3 States with Highest literacy
select top 3 State,concat( round(avg(Literacy),2) , ' %') as 'Lowest literacy' from data1
group by State order by avg(Literacy) desc;



-- top 3 states with highest population
select top 3 State,sum(Population) as 'Total Population' from data2
group by State order by sum(Population) desc;



-- top 3 states with least population
select top 3 State,sum(Population) as 'Total Population' from data2
group by State order by sum(Population);
 

 -- lets see how huch population is litrate and illiterate district wise
 with t1 as (
 select d1.District, d1.State,d1.Literacy, d2.Population 
 from data1 as d1 join data2 as d2 on d1.District = d2.District)
 select *, round((Population)*(Literacy)/100,0) as 'Literate People',
 round((Population)-((Population)*(Literacy)/100),0)  as 'Illiterate People' from t1;


  -- lets see how huch population is litrate and illiterate state wise
 with t1 as (
 select d1.District, d1.State,d1.Literacy, d2.Population 
 from data1 as d1 join data2 as d2 on d1.District = d2.District)
 select State, sum(round((Population)*(Literacy)/100,0)) as 'Literate People',
 sum(round((Population)-((Population)*(Literacy)/100),0))  as 'Illiterate People' from t1 group by State;


 --previous year population
  with t1 as (
 select d1.District, d1.State,d1.Growth, d2.Population 
 from data1 as d1 join data2 as d2 on d1.District = d2.District)
 Select *, round((Population/(1+(Growth/100))), 0) as 'Previous Population' from t1;


 -- previous population State wise
  with t1 as (
 select d1.District, d1.State,d1.Growth, d2.Population 
 from data1 as d1 join data2 as d2 on d1.District = d2.District)
 Select State, sum(round((Population/(1+(Growth/100))), 0)) as 'Previous Population' 
 from t1 group by State;


 --population of states per sqkm
 select State, Round((Sum(Population)/sum(Area_km2)),0) as 'Population per Square km' from data2 group by state;

 -- top 3 literate dist from each state having highest ratio
 select a.* from
 (select State,District,Literacy, rank() over (Partition by State order by Literacy desc) as rnk from data1) a
 where a.rnk in (1,2,3);

  -- top 3 literate dist from each state having least ratio
 select a.* from
 (select State,District,Literacy, rank() over (Partition by State order by Literacy) as rnk from data1) a
 where a.rnk in (1,2,3);
