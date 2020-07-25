Queries to answer questions

1. SELECT COUNT(*) FROM users;

2. SELECT COUNT(*) FROM transfers 
   WHERE send_amount_currency = 'CFA';

3. SELECT COUNT(u_id) FROM trnasfers
   WHERE send_amount_currency = 'CFA';

4. SELECT COUNT(atx_id) FROM agent_transactions
   WHERE EXTRACT(YEAR FROM when_created) = '2018'
   GROUP BY EXTRACT(MONTH FROM when_created);

5. WITH agentwithdrawers AS
   (SELECT COUNT(agent_id) AS netwithdrawers FROM agent_transactions
    HAVING COUNT(amount) IN (SELECT COUNT(amount) FROM agent_transactions WHERE amount > -1
    AND amount !=0 HAVING COUNT(amount) > (SELECT COUNT(amount)
    FROM agent_transactions WHERE amount < 1 AND amount != 0)))
    SELECT netwithdrawers FROM agentwithdrawers;

6. SELECT City,Volume INTO atx_volume_city_summary
   FROM (SELECT agents.city AS City,COUNT(agent_transactions.atx_id) AS Volume FROM agents
   INNER JOIN agents_transactions
   ON agents.agent_id = agent_transactions.agent_id
   WHERE (agent_transactions.when_created > (NOW() - INTERVAL '1 week'))
   GROUP BY agents.city) as atx_volume_summary;

7. SELECT City,Volume,Country INTO atx_volume_city_summary_with_Country
   FROM (SELECT agents.city AS City,agents.country AS Country,COUNT(agent_transactions.atx_id) AS Volume FROM agents
   INNER JOIN agent_transactions
   ON agents.agent_id = agent_transactions.agent_id
   WHERE (agent_transactions.when_created > (NOW() - INTERVAL '1 week'))
   GROUP BY agents.country,agents.city) AS atx_volume_summary_with_Country;

8. SELECT transfers.kind AS Kind, wallets.ledger_location AS Country,SUM(transfers.send_amount_scalar) AS Volume 
   FROM transfers
   INNER JOIN wallets
   ON transfers.source_wallet_id = wallets.wallet_id
   WHERE (transfers.when_created > (NOW() - INTERVAL '1 week'))
   GROUP BY wallets.ledger_location,transfers.kind;

9. SELECT COUNT(transfers.source_wallet_id) AS Unique_Senders, COUNT(transfer_id) AS Transaction_count, 
        transfers.kind AS Transfer_Kind, wallets.ledger_location AS Country, SUM(transfers.send_amount_scalar) AS Volume
   FROM transfers
   INNER JOIN wallets
   ON transfers.source_wallet_id = wallets.wallet_id
   WHERE (transfers.when_created > (NOW() - INTERVAL '1 week'))
   GROUP BY wallets.ledger_location, transfers.kind;

10. SELECT source_wallet_id,send_amount_scalar 
    FROM transfers
    WHERE send_amount_currency = 'CFA'
    AND (send_amount_scalar > 10000000)
    AND (transfers.when_created > (NOW() - INTERVAL '1 month'));