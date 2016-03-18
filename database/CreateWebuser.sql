CREATE USER 'webuser'@'localhost' IDENTIFIED BY 'webuser';
GRANT ar001.SELECT TO 'webuser';
-- it appears that we do not have the create user priviledge on our databases on hope