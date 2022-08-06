create trigger a
on parking
for insert
as begin
declare @free int,@pid varchar(50),@cid varchar(50)
select @pid=pid from inserted
select @cid=cid from inserted
select COUNT(*) from parking where cid=@cid
select @free=free from park where pid = @pid
if(@free>0)
begin
update park set free=@free-1 where pid = @pid
insert into car values(@cid,@pid,GETDATE(),null,null) 
end
else if(@free<=0)
begin
rollback
print('车位已满')
end

if(COUNT(*)>0)
begin
rollback
print('该车已在停车场中')
end
end

drop trigger a
insert into parking values('zh004','p03')

create trigger b
on parking
for delete
as begin
declare @ddif int,@pid varchar(50),@cid varchar(50),@tin datetime
select @pid=pid from deleted
select @cid=cid from deleted
select @tin=tin from car where cid=@cid and tout is null
select @ddif=datediff(ss,@tin,getdate())/60
update car set tout=getdate() where cid=@cid and tout is null
update park set free=free+1 where pid=@pid
if(@ddif<=10)
begin
 update car set money=0
end
else if(@ddif>10 and @ddif<=30)
begin
update car set money=10
end
else
begin
update car set money=@ddif-20
end
end

drop trigger b
delete from parking where cid='zh001'