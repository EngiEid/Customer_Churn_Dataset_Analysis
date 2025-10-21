USE Customer_Churn_DB;
GO
ALTER AUTHORIZATION ON DATABASE::[Customer_Churn_DB] TO [sa];
GO

-- Viewing the constraints on tables to make sure
EXEC sp_helpconstraint 'Fact_Customer_Churn';
EXEC sp_helpconstraint 'Dim_Customer';
EXEC sp_helpconstraint 'Dim_Contract';
EXEC sp_helpconstraint 'Dim_Subscription';

-- Determining the primary key of Fact Customer Churn table
ALTER TABLE Fact_Customer_Churn
ADD CONSTRAINT PK_FactCustomerChurn
PRIMARY KEY (CustomerID);
GO