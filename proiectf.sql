
DROP TABLE IF EXISTS bonuri_fiscale;
DROP TABLE IF EXISTS vanzari;
DROP TABLE IF EXISTS returnari_inchirieri;
DROP TABLE IF EXISTS inchirieri;
DROP TABLE IF EXISTS inventar;
DROP TABLE IF EXISTS sesiune_de_joc;
DROP TABLE IF EXISTS personal;
DROP TABLE IF EXISTS saladejocuri;
DROP TABLE IF EXISTS clienti;
DROP TABLE IF EXISTS membership;
DROP TABLE IF EXISTS tipclient;
DROP TABLE IF EXISTS jocuri;
DROP TABLE IF EXISTS consola;

 CREATE TABLE consola (
    idconsola SERIAL PRIMARY KEY,
    nume VARCHAR(100) NOT NULL,
    brand VARCHAR(100) NOT NULL
);

CREATE TABLE jocuri (
    idjoc SERIAL PRIMARY KEY,
    numejoc VARCHAR(100) NOT NULL,
    idconsola INT NOT NULL REFERENCES consola(idconsola) ON DELETE CASCADE,
    pret DECIMAL(10, 2) NOT NULL CHECK (pret >= 0),
    UNIQUE (numejoc, idconsola)
);

CREATE TABLE tipclient (
    idtipclient SERIAL PRIMARY KEY,
    facilitati TEXT NOT NULL,
    denumiretip VARCHAR(50) NOT NULL,
    UNIQUE (denumiretip)
);

CREATE TABLE membership (
    idmembership SERIAL PRIMARY KEY,
    idtipclient INT NOT NULL REFERENCES tipclient(idtipclient) ON DELETE CASCADE,
    data_start DATE NOT NULL,
    data_end DATE NOT NULL,
    CHECK (data_end > data_start)
);

CREATE TABLE clienti (
    idclient SERIAL PRIMARY KEY,
    cnp VARCHAR(13) NOT NULL,
    nume VARCHAR(100) NOT NULL,
    idmembership INT REFERENCES membership(idmembership) ON DELETE SET NULL,
    data_accesarii DATE NOT NULL DEFAULT CURRENT_DATE,
    ora_accesarii TIME NOT NULL DEFAULT CURRENT_TIME,
    UNIQUE (cnp)
);

CREATE TABLE saladejocuri (
    idsala SERIAL PRIMARY KEY,
    numesala VARCHAR(100) NOT NULL,
    adresa VARCHAR(255) NOT NULL,
    idclient INT REFERENCES clienti(idclient) ON DELETE SET NULL,
    data_accesarii DATE NOT NULL DEFAULT CURRENT_DATE,
    ora_accesarii TIME NOT NULL DEFAULT CURRENT_TIME
);

CREATE TABLE personal (
    idangajat SERIAL PRIMARY KEY,
    nume VARCHAR(100) NOT NULL,
    idsala INT REFERENCES saladejocuri(idsala) ON DELETE SET NULL,
    data_angajarii DATE NOT NULL,
    pozitie VARCHAR(50) NOT NULL
);

CREATE TABLE sesiune_de_joc (
    idsesiunejoc SERIAL PRIMARY KEY,
    idclient INT NOT NULL REFERENCES clienti(idclient) ON DELETE CASCADE,
    idjoc INT NOT NULL REFERENCES jocuri(idjoc) ON DELETE CASCADE,
    idconsola INT NOT NULL REFERENCES consola(idconsola) ON DELETE CASCADE,
    data_end DATE NOT NULL
);

CREATE TABLE inventar (
    idinventar SERIAL PRIMARY KEY,
    idconsola INT NOT NULL REFERENCES consola(idconsola) ON DELETE CASCADE,
    idjoc INT NOT NULL REFERENCES jocuri(idjoc) ON DELETE CASCADE,
    data_adaugare DATE NOT NULL,
    data_actualizare DATE NOT NULL,
    UNIQUE (idconsola, idjoc)
);

CREATE TABLE inchirieri (
    idinchiriere SERIAL PRIMARY KEY,
    idclient INT NOT NULL REFERENCES clienti(idclient) ON DELETE CASCADE,
    data_inceput DATE NOT NULL,
    data_retur DATE NOT NULL CHECK (data_retur >= data_inceput)
);

CREATE TABLE returnari_inchirieri (
    idretur SERIAL PRIMARY KEY,
    idinchiriere INT NOT NULL REFERENCES inchirieri(idinchiriere) ON DELETE CASCADE,
    idjoc INT NOT NULL REFERENCES jocuri(idjoc) ON DELETE CASCADE,
    data_retur DATE NOT NULL
);

CREATE TABLE vanzari (
    idvanzare SERIAL PRIMARY KEY,
    idclient INT NOT NULL REFERENCES clienti(idclient) ON DELETE CASCADE,
    idjoc INT NOT NULL REFERENCES jocuri(idjoc) ON DELETE CASCADE,
    tip_tranzactie VARCHAR(50) NOT NULL,
    data_achizitie DATE NOT NULL,
    ora_achizitie TIME NOT NULL,
    pret DECIMAL(10, 2) NOT NULL CHECK (pret >= 0),
    cantitate INT NOT NULL CHECK (cantitate > 0)
);

CREATE TABLE bonuri_fiscale (
    idbon SERIAL PRIMARY KEY,
    idvanzare INT NOT NULL REFERENCES vanzari(idvanzare) ON DELETE CASCADE,
    data_actualizare DATE NOT NULL DEFAULT CURRENT_DATE,
    ora_actualizare TIME NOT NULL DEFAULT CURRENT_TIME,
    suma DECIMAL(10, 2) NOT NULL CHECK (suma >= 0),
    metoda_plata VARCHAR(50) NOT NULL
);



DELETE FROM consola;
DELETE FROM jocuri;
DELETE FROM tipclient;
DELETE FROM membership;
DELETE FROM clienti;
DELETE FROM saladejocuri;
DELETE FROM personal;
DELETE FROM sesiune_de_joc;
DELETE FROM inventar;
DELETE FROM inchirieri;
DELETE FROM returnari_inchirieri;
DELETE FROM vanzari;
DELETE FROM bonuri_fiscale;



INSERT INTO consola (idconsola,nume, brand) VALUES
(1,'PlayStation 5', 'Sony'),
(2,'Xbox Series X', 'Microsoft'),
(3,'Nintendo Switch', 'Nintendo'),
(4,'PlayStation 4', 'Sony'),
(5,'Xbox One', 'Microsoft'),
(7,'Nintendo Wii', 'Nintendo'),
(6,'PlayStation 3', 'Sony'),
(8,'Xbox 360', 'Microsoft'),
(9,'Nintendo 64', 'Nintendo'),
(10,'PlayStation 2', 'Sony');


INSERT INTO jocuri (numejoc, idconsola, pret) VALUES
('The Last of Us Part II', 1, 59.99),
('Halo Infinite', 2, 69.99),
('The Legend of Zelda: Breath of the Wild', 3, 59.99),
('God of War', 4, 39.99),
('Forza Horizon 4', 5, 49.99),
('Super Mario Odyssey', 3, 59.99),
('Uncharted 4', 4, 19.99),
('Gears 5', 2, 49.99),
('Metroid Prime', 9, 29.99),
('Gran Turismo 7', 1, 69.99);


INSERT INTO tipclient (facilitati, denumiretip) VALUES
('40% Discount, Prioritate la sali,O sesiune de joc gratuita', 'Premium'),
('-', 'Standard'),
('30% Discount, Prioritate la sali,O sesiune de joc gratuita', 'Gold'),
('20% Discount', 'Silver'),
('Priority support', 'Support'),
('O sesiune de joc gratuita', 'Monthly Free Game'),
('Discount la inchirieri', ' Discount'),
('O saptamana in plus la inchirieri', 'Extended Rental'),
('Acces la jocuri noi', 'Beta Tester'),
('Pachet de familie', 'Family');

INSERT INTO membership (idtipclient, data_start, data_end) VALUES
(1, '2023-01-01', '2024-01-01'),
(2, '2023-01-01', '2024-01-01'),
(3, '2023-01-01', '2024-01-01'),
(4, '2023-01-01', '2024-01-01'),
(5, '2023-01-01', '2024-01-01'),
(6, '2023-01-01', '2024-01-01'),
(7, '2023-01-01', '2024-01-01'),
(8, '2023-01-01', '2024-01-01'),
(9, '2023-01-01', '2024-01-01'),
(10, '2023-01-01', '2024-01-01');


INSERT INTO clienti (cnp, nume, idmembership) VALUES
('1234567890123', 'Angel A', 1),
('2345678901234', 'Andrei B', 2),
('3456789012345', 'Dwayne Johnson', 3),
('4567890123456', 'Travis Scott', 4),
('5678901234567', 'John C', 5),
('6789012345678', 'Kid Cudi', 6),
('7890123456789', 'Peter Parker', 7),
('8901234567890', 'Marshal Mathers', 8),
('9012345678901', 'Jessie Pinkman', 9),
('0123456789012', 'Hank ', 10);


INSERT INTO saladejocuri (numesala, adresa, idclient) VALUES
('Sala 1', '123 Main St', 1),
('VIP Lounge', '456 High St', 2),
('Sala 2', '789 Park Ave', 3),
('Jocuri Arcade', '1011 Fun St', 4),
('Sala 3', '1213 Old St', 5),
('Magazin', '1415 Game St', 6),
('Sala Inchirieri', '1617 Kids St', 7),
('Sala 4', '1819 Indie St', 8),
('Sala 5', '2021 Strategy St', 9),
('Sala 5', '2223 Adventure St', 10);


INSERT INTO personal (nume, idsala, data_angajarii, pozitie) VALUES
('Michael Scott', 1, '2022-01-01', 'Manager'),
('Dwight Schrute', 2, '2022-02-01', 'Asistent Manager'),
('Jim Halpert', 3, '2022-03-01', 'Vanzator'),
('Pam Beesly', 4, '2022-04-01', 'Receptionist'),
('Stanley Hudson', 5, '2022-05-01', 'Staff'),
('Ryan Howard', 6, '2022-06-01', 'Intern'),
('Andy Bernard', 7, '2022-07-01', 'Vanzator'),
('Robert California', 8, '2022-08-01', 'CEO'),
('Oscar Martinez', 9, '2022-09-01', 'Accountant'),
('Angela Martin', 10, '2022-10-01', 'Accountant');

-- Insert into sesiune_de_joc
INSERT INTO sesiune_de_joc (idclient, idjoc, idconsola, data_end) VALUES
(1, 1, 1, '2023-12-31'),
(2, 2, 2, '2023-12-31'),
(3, 3, 3, '2023-12-31'),
(4, 4, 4, '2023-12-31'),
(5, 5, 5, '2023-12-31'),
(6, 6, 3, '2023-12-31'),
(7, 7, 4, '2023-12-31'),
(8, 8, 2, '2023-12-31'),
(9, 9, 9, '2023-12-31'),
(10, 10, 1, '2023-12-31');


INSERT INTO inventar (idconsola, idjoc, data_adaugare, data_actualizare) VALUES
(1, 1, '2022-01-01', '2023-01-01'),
(2, 2, '2022-02-01', '2023-02-01'),
(3, 3, '2022-03-01', '2023-03-01'),
(4, 4, '2022-04-01', '2023-04-01'),
(5, 5, '2022-05-01', '2023-05-01'),
(3, 6, '2022-06-01', '2023-06-01'),
(4, 7, '2022-07-01', '2023-07-01'),
(2, 8, '2022-08-01', '2023-08-01'),
(9, 9, '2022-09-01', '2023-09-01'),
(1, 10, '2022-10-01', '2023-10-01');


INSERT INTO inchirieri (idclient, data_inceput, data_retur) VALUES
(1, '2023-01-01', '2023-01-15'),
(2, '2023-01-05', '2023-01-20'),
(3, '2023-01-10', '2023-01-25'),
(4, '2023-01-15', '2023-01-30'),
(5, '2023-01-20', '2023-02-05'),
(6, '2023-01-25', '2023-02-10'),
(7, '2023-02-01', '2023-02-15'),
(8, '2023-02-05', '2023-02-20'),
(9, '2023-02-10', '2023-02-25'),
(10, '2023-02-15', '2023-03-01');

INSERT INTO returnari_inchirieri (idinchiriere, idjoc, data_retur) VALUES
(1, 1, '2023-01-15'),
(2, 2, '2023-01-20'),
(3, 3, '2023-01-25'),
(4, 4, '2023-01-30'),
(5, 5, '2023-02-05'),
(6, 6, '2023-02-10'),
(7, 7, '2023-02-15'),
(8, 8, '2023-02-20'),
(9, 9, '2023-02-25'),
(10, 10, '2023-03-01');


INSERT INTO vanzari (idclient, idjoc, tip_tranzactie, data_achizitie, ora_achizitie, pret, cantitate) VALUES
(1, 1, 'Cumparare', '2023-01-01', '10:00', 59.99, 1),
(2, 2, 'Cumparare', '2023-01-05', '11:00', 69.99, 1),
(3, 3, 'Cumparare', '2023-01-10', '12:00', 59.99, 1),
(4, 4, 'Cumparare', '2023-01-15', '13:00', 39.99, 1),
(5, 5, 'Cumparare', '2023-01-20', '14:00', 49.99, 1),
(6, 6, 'Cumparare', '2023-01-25', '15:00', 59.99, 1),
(7, 7, 'Cumparare', '2023-02-01', '16:00', 19.99, 1),
(8, 8, 'Cumparare', '2023-02-05', '17:00', 49.99, 1),
(9, 9, 'Cumparare', '2023-02-10', '18:00', 29.99, 1),
(10, 10, 'Cumparare', '2023-02-15', '19:00', 69.99, 1);


INSERT INTO bonuri_fiscale (idvanzare, data_actualizare, ora_actualizare, suma, metoda_plata) VALUES
(1, '2023-01-01', '10:05', 59.99, 'Card'),
(2, '2023-01-05', '11:05', 69.99, 'Cash'),
(3, '2023-01-10', '12:05', 59.99, 'Card'),
(4, '2023-01-15', '13:05', 39.99, 'Card'),
(5, '2023-01-20', '14:05', 49.99, 'Cash'),
(6, '2023-01-25', '15:05', 59.99, 'Card'),
(7, '2023-02-01', '16:05', 19.99, 'Cash'),
(8, '2023-02-05', '17:05', 49.99, 'Card'),
(9, '2023-02-10', '18:05', 29.99, 'Card'),
(10, '2023-02-15', '19:05', 69.99, 'Cash');



