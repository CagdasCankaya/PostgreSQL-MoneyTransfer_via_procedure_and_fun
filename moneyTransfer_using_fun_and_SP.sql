create table Accounts(id int primary key, accountName varchar(50), sumOfMoney float);
insert into Accounts values (1,'Account A',1000);
insert into Accounts values (2,'Account B', 500);
select * from Accounts;


--Money transfer with function:
create or replace function moneyTransfer(fromAccount int, toAccount int, amount float) returns void as $$
begin
	if (select sumOfMoney from Accounts where id = fromAccount) < amount then
    raise exception 'There is no money in the account %', (select accountName from Accounts where id = fromAccount);
	end if;
	
       --get money from main account
	UPDATE Accounts SET sumOfMoney = sumOfMoney - amount WHERE id = fromAccount;

	--put money into target account
	UPDATE Accounts SET sumOfMoney = sumOfMoney + amount WHERE id = toAccount;
	

	EXCEPTION
		WHEN OTHERS THEN
		
		RAISE;
END;
$$ LANGUAGE plpgsql;

select moneyTransfer(1, 2, 200);
select * from Accounts;




-- Money transfer with SP
create or replace procedure moneyTransferProcedure(fromAccount int, toAccount int, amount float)
LANGUAGE plpgsql
AS $$
BEGIN
    IF (SELECT sumOfMoney FROM Accounts WHERE id = fromAccount) < amount THEN
        RAISE EXCEPTION 'There is no money in the account %', (select accountName from Accounts where id = fromAccount);
    END IF;

	--get money from main account
    UPDATE Accounts SET sumOfMoney = sumOfMoney - amount WHERE id = fromAccount;

	--put money into target account
    UPDATE Accounts SET sumOfMoney = sumOfMoney + amount WHERE id = toAccount;

   	EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'An error occurred: %', SQLERRM;
END;
$$;

CALL moneyTransferProcedure(2,1,200);
SELECT * FROM Accounts;














