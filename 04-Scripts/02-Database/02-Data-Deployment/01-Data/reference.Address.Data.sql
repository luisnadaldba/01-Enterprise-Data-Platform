/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : reference.Address
    Type        : Reference / Sample Data
    Prefix      : ADR
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the reusable street references used by the AtlasCommerce sample
    data.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Inserts only addresses that do not already exist.
    - Existing addresses are preserved without modification.
    - No automatic UPDATE is performed.
    - ADR_CTY_id + ADR_postal_code + ADR_street are used to identify an
      existing address.
    - City dependencies are resolved by Administrative Division code and city
      name.
    - Postal codes correspond to the referenced Brazilian city.
    - Street names are synthetic and do not represent real customer addresses.
    - Source data is validated for duplicate address definitions.
    - Data is deployed using a grouped set-based operation.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● reference.Address';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @ADR_data_timestamp datetime2(0) = SYSDATETIME();
DECLARE @ADR_rows_added     int;
DECLARE @ADR_rows_processed int;

DECLARE @ADR_source TABLE
(
    ADV_code        char(2)       NOT NULL,
    CTY_name        nvarchar(150) NOT NULL,
    ADR_postal_code varchar(8)    NOT NULL,
    ADR_street      nvarchar(200) NOT NULL
);


/*==============================================================================
    SOURCE DATA
==============================================================================*/

INSERT INTO @ADR_source
(
    ADV_code,
    CTY_name,
    ADR_postal_code,
    ADR_street
)
VALUES
    ('AC', N'Rio Branco', '69900001', N'Rua Marechal Toledo'),
    ('AC', N'Rio Branco', '69900001', N'Avenida Rio Branco'),
    ('AC', N'Cruzeiro do Sul', '69980000', N'Rua das Acácias'),

    ('AL', N'Maceió', '57000001', N'Rua Alvorada'),
    ('AL', N'Maceió', '57000001', N'Avenida das Palmeiras'),
    ('AL', N'Arapiraca', '57300000', N'Rua Hugo Ferreira'),

    ('AP', N'Macapá', '68900001', N'Rua Minas Gerais'),
    ('AP', N'Macapá', '68900001', N'Avenida Epaminondas Pacheco'),
    ('AP', N'Santana', '68925001', N'Rua Eustáquio Timbó'),

    ('AM', N'Manaus', '69000001', N'Rua Floriano Alencar'),
    ('AM', N'Manaus', '69000001', N'Avenida Getúlio Vargas'),
    ('AM', N'Manaus', '69000001', N'Rua Minas Gerais'),
    ('AM', N'Parintins', '69150000', N'Rua Omar Spazzio'),

    ('BA', N'Salvador', '40000001', N'Rua das Macieiras'),
    ('BA', N'Salvador', '40000001', N'Avenida Atlântica'),
    ('BA', N'Salvador', '40000001', N'Rua Direta do Papagaio'),
    ('BA', N'Feira de Santana', '44000001', N'Silveira da Silva'),
    ('BA', N'Feira de Santana', '44000001', N'Avenida Elisa Garibaldi'),
    ('BA', N'Vitória da Conquista', '45000000', N'Rua Estados Unidos'),

    ('CE', N'Fortaleza', '60000001', N'Rua Alfredo de Brito'),
    ('CE', N'Fortaleza', '60000001', N'Avenida Limoeiro'),
    ('CE', N'Fortaleza', '60000001', N'Avenida Centenário'),
    ('CE', N'Juazeiro do Norte', '63000000', N'Rua Marquês de Malta'),
    ('CE', N'Juazeiro do Norte', '63000000', N'Avenida Flamengo'),
    ('CE', N'Sobral', '62010000', N'Rua Miguel Herrera'),

    ('DF', N'Brasília', '70040000', N'Rua César Gomes'),
    ('DF', N'Brasília', '70040000', N'Avenida Sete de Setembro'),
    ('DF', N'Brasília', '70040000', N'Avenida Vinte Um de Abril'),

    ('ES', N'Vitória', '29000001', N'Rua Alfredo de Brito'),
    ('ES', N'Vitória', '29000001', N'Avenida Tancredo Neves'),
    ('ES', N'Serra', '29160001', N'Rua Atlas de Algoritmo'),
    ('ES', N'Serra', '29160001', N'Avenida São Paulo'),
    ('ES', N'Vila Velha', '29100001', N'Rua Diórgenes Fonseca'),
    ('ES', N'Vila Velha', '29100001', N'Avenida Primária'),

    ('GO', N'Goiânia', '74000001', N'Rua 599'),
    ('GO', N'Goiânia', '74000001', N'Avenida T-146'),
    ('GO', N'Goiânia', '74000001', N'Avenida T-1'),
    ('GO', N'Anápolis', '75000000', N'Rua das Acácias'),
    ('GO', N'Anápolis', '75000000', N'Rua Engenheiro Mangueira'),
    ('GO', N'Aparecida de Goiânia', '74900000', N'Rua Tonico de Melo'),
    ('GO', N'Aparecida de Goiânia', '74900000', N'Avenida Rio Negro'),

    ('MA', N'São Luís', '65000001', N'Rua Júlio Nasser'),
    ('MA', N'São Luís', '65000001', N'Avenida São Francisco'),
    ('MA', N'Imperatriz', '65900000', N'Rua Desembargador Palhares'),

    ('MT', N'Cuiabá', '78000000', N'Rua Marechal Joaquim Inácio'),
    ('MT', N'Cuiabá', '78000000', N'Avenida Brasil'),
    ('MT', N'Rondonópolis', '78700000', N'Rua Manoel D''Ignacio'),

    ('MS', N'Campo Grande', '79000001', N'Rua Tenente Batista'),
    ('MS', N'Campo Grande', '79000001', N'Avenida Juscelino Kubitschek'),
    ('MS', N'Dourados', '79800000', N'Rua Rio de Janeiro'),

    ('MG', N'Belo Horizonte', '30000001', N'Rua Jamel Cecílio'),
    ('MG', N'Belo Horizonte', '30000001', N'Avenida São Francisco'),
    ('MG', N'Belo Horizonte', '30000001', N'Avenida Presidente Kennedy'),
    ('MG', N'Contagem', '32000001', N'Rua Edson Barbosa'),
    ('MG', N'Contagem', '32000001', N'Avenida Universitária'),
    ('MG', N'Juiz de Fora', '36000001', N'Rua Pedro Ludovico'),
    ('MG', N'Juiz de Fora', '36000001', N'Avenida Quinze de Novembro'),
    ('MG', N'Pouso Alegre', '37550001', N'Rua Farid Abou Medeiros'),
    ('MG', N'Uberlândia', '38400001', N'Rua Barão do Rio Branco'),
    ('MG', N'Uberlândia', '38400001', N'Avenida MInas Gerais'),

    ('PA', N'Belém', '66000001', N'Rua Sapucaí'),
    ('PA', N'Belém', '66000001', N'Avenida Nossa Senhora do Carmo'),
    ('PA', N'Belém', '66000001', N'Avenida Cristiano Ronaldo'),
    ('PA', N'Ananindeua', '67000000', N'Rua Sergipe'),
    ('PA', N'Ananindeua', '67000000', N'Avenida Presidente Antônio Carlos'),
    ('PA', N'Santarém', '68000000', N'Rua dos Aimorés'),

    ('PB', N'João Pessoa', '58000001', N'Rua Hernandez Tourinho'),
    ('PB', N'João Pessoa', '58000001', N'Avenida Getúlio Vargas'),
    ('PB', N'Campina Grande', '58400001', N'Rua Grécia'),
    ('PB', N'Campina Grande', '58400001', N'Avenida Dom Pedro II'),
    ('PB', N'Patos', '58700000', N'Rua Brasil'),

    ('PR', N'Curitiba', '80000001', N'Rua dos Aimorés'),
    ('PR', N'Curitiba', '80000001', N'Avenida Brasil'),
    ('PR', N'Curitiba', '80000001', N'Alameda Espírito Santo'),
    ('PR', N'Cascavel', '85800000', N'Rua dos Goitacazes'),
    ('PR', N'Cascavel', '85800000', N'Avenida Limeira'),
    ('PR', N'Londrina', '86000001', N'Rua da Bahia'),
    ('PR', N'Londrina', '86000001', N'Avenida das Goiabeiras'),
    ('PR', N'Maringá', '87000000', N'Rua Luis Nadal'),
    ('PR', N'Maringá', '87000000', N'Avenida Cristóvão Colombo'),

    ('PE', N'Recife', '50000001', N'Rua Liberdade'),
    ('PE', N'Recife', '50000001', N'Avenida Pedro Álvarez Cabral'),
    ('PE', N'Recife', '50000001', N'Alameda Porfírio Silvestre'),
    ('PE', N'Caruaru', '55000000', N'Rua Sergipe'),
    ('PE', N'Caruaru', '55000000', N'Avenida Nossa Senhora do Carmo'),
    ('PE', N'Jaboatão dos Guararapes', '54000001', N'Rua do Contorno'),
    ('PE', N'Jaboatão dos Guararapes', '54000001', N'Avenida Nações Unidas'),
    ('PE', N'Olinda', '53000001', N'Rua Estados Unidos'),
    ('PE', N'Olinda', '53000001', N'Avenida Cidade do México'),

    ('PI', N'Teresina', '64000001', N'Rua Félix Feliz'),
    ('PI', N'Teresina', '64000001', N'Avenida Centenário Oriental'),
    ('PI', N'Parnaíba', '64200000', N'Rua Fernandópolis'),

    ('RJ', N'Rio de Janeiro', '20000001', N'Rua das Flores'),
    ('RJ', N'Rio de Janeiro', '20000001', N'Avenida Silva Jardim'),
    ('RJ', N'Rio de Janeiro', '20000001', N'Alameda dos Pernetas'),
    ('RJ', N'Duque de Caxias', '25000001', N'Rua Saldanha Rubro'),
    ('RJ', N'Duque de Caxias', '25000001', N'Avenida Visconde de Sabugosa'),
    ('RJ', N'Niterói', '24000000', N'Rua João Gualberto'),
    ('RJ', N'Niterói', '24000000', N'Avenida Prefeito Abreu'),
    ('RJ', N'Petrópolis', '25600000', N'Rua Victor Ferreira do Amaral'),
    ('RJ', N'São Gonçalo', '24400001', N'Rua Brigadeiro Franco'),
    ('RJ', N'São Gonçalo', '24400001', N'Avenida Francisco Ribas'),

    ('RN', N'Natal', '59000001', N'Rua Geraldo de Andrade'),
    ('RN', N'Natal', '59000001', N'Avenida Botelho'),
    ('RN', N'Mossoró', '59600000', N'Rua Mateus Leme'),
    ('RN', N'Parnamirim', '59140000', N'Rua Sete de Setembro'),

    ('RS', N'Porto Alegre', '90000001', N'Rua Itupava'),
    ('RS', N'Porto Alegre', '90000001', N'Avenida Sete de Setembro'),
    ('RS', N'Porto Alegre', '90000001', N'Alameda Oito'),
    ('RS', N'Canoas', '92000000', N'Rua Brigadeiro Celeste'),
    ('RS', N'Canoas', '92000000', N'Avenida Silva Jardim'),
    ('RS', N'Caxias do Sul', '95000000', N'Rua Comendador Araújo'),
    ('RS', N'Caxias do Sul', '95000000', N'Avenida São Judas'),
    ('RS', N'Pelotas', '96000000', N'Rua Jesus de Nazaré'),

    ('RO', N'Porto Velho', '76800000', N'Rua Fernando Fernandes'),
    ('RO', N'Porto Velho', '76800000', N'Presidente Affonso Camargo'),
    ('RO', N'Ji-Paraná', '76900000', N'Rua Guilherme Souza'),

    ('RR', N'Boa Vista', '69300000', N'Rua dos Pangós'),

    ('SC', N'Florianópolis', '88000001', N'Rua Dias Ferreira'),
    ('SC', N'Florianópolis', '88000001', N'Avenida Niemeyer'),
    ('SC', N'Blumenau', '89000001', N'Rua Jardim Botânico'),
    ('SC', N'Blumenau', '89000001', N'Avenida Brasil'),
    ('SC', N'Joinville', '89200001', N'Rua Zildo Pessoa'),
    ('SC', N'Joinville', '89200001', N'Avenida Oceânica'),

    ('SP', N'São Paulo', '01001000', N'Rua das Libélulas'),
    ('SP', N'São Paulo', '01001000', N'Avenida Oscar Niemeyer'),
    ('SP', N'São Paulo', '01001000', N'Alameda Mestre Atlas'),
    ('SP', N'Campinas', '13000001', N'Rua Haddock Urso'),
    ('SP', N'Campinas', '13000001', N'Avenida Rodrigues Marques'),
    ('SP', N'Campinas', '13000001', N'Alameda Pasteur'),
    ('SP', N'Guarulhos', '07000001', N'Rua do Ouvidor'),
    ('SP', N'Guarulhos', '07000001', N'Rua Onze'),
    ('SP', N'Guarulhos', '07000001', N'Avenida 25 de Dezembro'),
    ('SP', N'Peruíbe', '11750000', N'Rua do Baratão'),
    ('SP', N'Ribeirão Preto', '14000000', N'Rua Y'),
    ('SP', N'Ribeirão Preto', '14000000', N'Avenida Conde de Bonfim'),
    ('SP', N'Santos', '11000000', N'Rua Primo Ferreira'),
    ('SP', N'Santos', '11000000', N'Avenida João Silvestre'),
    ('SP', N'São José dos Campos', '12200001', N'Rua das Amoreiras'),
    ('SP', N'São José dos Campos', '12200001', N'Avenida das Américas'),

    ('SE', N'Aracaju', '49000001', N'Rua Samto Antônio'),
    ('SE', N'Aracaju', '49000001', N'Avenida Padre MIguel Stéfano'),
    ('SE', N'Nossa Senhora do Socorro', '49160000', N'Alameda dos Açais'),

    ('TO', N'Palmas', '77000000', N'Rua Tuiuiú Vesgo'),
    ('TO', N'Palmas', '77000000', N'Avenida Palmital'),
    ('TO', N'Araguaína', '77800000', N'Rua Rio Negro');


/*==============================================================================
    SOURCE VALIDATION
==============================================================================*/

IF EXISTS
(
    SELECT
        S.ADV_code,
        S.CTY_name,
        S.ADR_postal_code,
        S.ADR_street
    FROM @ADR_source AS S
    GROUP BY
        S.ADV_code,
        S.CTY_name,
        S.ADR_postal_code,
        S.ADR_street
    HAVING COUNT(*) > 1
)
BEGIN

    ;THROW 50570,
        N'reference.Address source data contains duplicate address definitions.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @ADR_source AS S
    WHERE LEN(S.ADR_postal_code) <> 8
       OR S.ADR_postal_code LIKE '%[^0-9]%'
)
BEGIN

    ;THROW 50571,
        N'reference.Address source data contains an invalid postal code.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @ADR_source AS S
    WHERE LEN(LTRIM(RTRIM(S.ADR_street))) = 0
)
BEGIN

    ;THROW 50572,
        N'reference.Address source data contains an empty street name.',
        1;

END;


/*==============================================================================
    DEPENDENCY VALIDATION
==============================================================================*/

IF EXISTS
(
    SELECT 1
    FROM @ADR_source AS S

    LEFT JOIN reference.AdministrativeDivision AS A
        ON A.ADV_code = S.ADV_code

    LEFT JOIN reference.City AS C
        ON  C.CTY_ADV_id = A.ADV_id
        AND C.CTY_name = S.CTY_name

    WHERE C.CTY_id IS NULL
)
BEGIN

    ;THROW 50573,
        N'reference.Address data deployment requires all referenced City records.',
        1;

END;


/*==============================================================================
    DATA DEPLOYMENT
==============================================================================*/

SELECT
    @ADR_rows_processed = COUNT(*)
FROM @ADR_source;


INSERT INTO reference.Address
(
    ADR_CTY_id,
    ADR_postal_code,
    ADR_street,
    ADR_created_at,
    ADR_updated_at
)
SELECT
    C.CTY_id,
    S.ADR_postal_code,
    S.ADR_street,
    @ADR_data_timestamp,
    @ADR_data_timestamp
FROM @ADR_source AS S

INNER JOIN reference.AdministrativeDivision AS A
    ON A.ADV_code = S.ADV_code

INNER JOIN reference.City AS C
    ON  C.CTY_ADV_id = A.ADV_id
    AND C.CTY_name = S.CTY_name

WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.Address AS R
    WHERE R.ADR_CTY_id = C.CTY_id
      AND R.ADR_postal_code = S.ADR_postal_code
      AND R.ADR_street = S.ADR_street
);


SET @ADR_rows_added = @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @ADR_rows_added);

PRINT N'        [•] Rows already existing            : '
    + CONVERT(nvarchar(20), @ADR_rows_processed - @ADR_rows_added);

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @ADR_rows_processed);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';