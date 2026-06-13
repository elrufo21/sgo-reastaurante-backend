USE [master]
GO
/****** Object:  Database [SAPECHI_T_A]    Script Date: 13/06/2026 10:10:18 ******/
CREATE DATABASE [SAPECHI_T_A] ON  PRIMARY 
( NAME = N'SAPECHI_T_A', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL10_50.SQLEXPSS_2008\MSSQL\DATA\SAPECHI_T_A.mdf' , SIZE = 39168KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'SAPECHI_T_A_log', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL10_50.SQLEXPSS_2008\MSSQL\DATA\SAPECHI_T_A_1.LDF' , SIZE = 526336KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [SAPECHI_T_A] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SAPECHI_T_A].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SAPECHI_T_A] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SAPECHI_T_A] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SAPECHI_T_A] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SAPECHI_T_A] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SAPECHI_T_A] SET ARITHABORT OFF 
GO
ALTER DATABASE [SAPECHI_T_A] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SAPECHI_T_A] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SAPECHI_T_A] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SAPECHI_T_A] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SAPECHI_T_A] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SAPECHI_T_A] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SAPECHI_T_A] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SAPECHI_T_A] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SAPECHI_T_A] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SAPECHI_T_A] SET  DISABLE_BROKER 
GO
ALTER DATABASE [SAPECHI_T_A] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SAPECHI_T_A] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SAPECHI_T_A] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SAPECHI_T_A] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SAPECHI_T_A] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SAPECHI_T_A] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SAPECHI_T_A] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SAPECHI_T_A] SET RECOVERY FULL 
GO
ALTER DATABASE [SAPECHI_T_A] SET  MULTI_USER 
GO
ALTER DATABASE [SAPECHI_T_A] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SAPECHI_T_A] SET DB_CHAINING OFF 
GO
USE [SAPECHI_T_A]
GO
/****** Object:  UserDefinedFunction [dbo].[CalcularEdad]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[CalcularEdad]
(
    @FecNac             date
)
RETURNS int
AS
BEGIN
declare 
 @fechaActual date,
 @anioNacimiento int,
 @mesNacimiento int,
 @diaNacimiento int,
 @añoActual int,
 @mesActual int,
 @diaActual int,
 @anios int

set @fechaActual=getdate()
set @anioNacimiento = year(@FecNac)
set @mesNacimiento = month(@FecNac)
set @diaNacimiento = day(@FecNac)

set @añoActual = CONVERT(int,year(@fechaActual))
set @mesActual = CONVERT(int,month(@fechaActual))
set @diaActual = CONVERT(int,day(@fechaActual))



set @anios = @añoActual - @anioNacimiento

if ((@mesActual - @mesNacimiento)<0)
begin
if (@anioNacimiento<@añoActual)
   set @anios=@anios-1 
end

if ((@mesActual = @mesNacimiento))
begin
   if (@diaNacimiento>@diaActual)
   set @anios=@anios-1 
end

RETURN @anios
END
GO
/****** Object:  UserDefinedFunction [dbo].[desincrectar]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[desincrectar]
( @clave varbinary(500))

 returns varchar(100)
 as
 begin
 declare @pass as varchar(50)
 set @pass=DECRYPTBYPASSPHRASE('clave',@clave)
 return @pass
 end
GO
/****** Object:  UserDefinedFunction [dbo].[diaNombre]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[diaNombre]
(@fecha datetime)
returns nvarchar(20)
as
begin
declare @NomDia nvarchar(20)	 
	 if (DATEPART(dw,@fecha)=1)set @NomDia='Lunes'
	 if (DATEPART(dw,@fecha)=2)set @NomDia='Martes'
	 if (DATEPART(dw,@fecha)=3)set @NomDia='Miercoles'
	 if (DATEPART(dw,@fecha)=4)set @NomDia='Jueves'
	 if (DATEPART(dw,@fecha)=5)set @NomDia='Viernes'
	 if (DATEPART(dw,@fecha)=6)set @NomDia='Sabado'
	 if (DATEPART(dw,@fecha)=7)set @NomDia='Domingo'
 return @Nomdia
end
GO
/****** Object:  UserDefinedFunction [dbo].[encriptar]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[encriptar]
( @clave varchar(50))
 returns varbinary(500)
 as
 begin
 declare @pass as varbinary(500)
 set @pass=ENCRYPTBYPASSPHRASE('clave',@clave)
 return @pass
 end
GO
/****** Object:  UserDefinedFunction [dbo].[fnSplitString]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnSplitString] 
( 
    @string VARCHAR(MAX), 
    @delimiter CHAR(1) 
) 
RETURNS @output TABLE(splitdata VARCHAR(MAX) 
) 
BEGIN 
    DECLARE @start INT, @end INT 
    SELECT @start = 1, @end = CHARINDEX(@delimiter, @string) 
    WHILE @start < LEN(@string) + 1 BEGIN 
        IF @end = 0  
            SET @end = LEN(@string) + 1
       
        INSERT INTO @output (splitdata)  
        VALUES(SUBSTRING(@string, @start, @end - @start)) 
        SET @start = @end + 1 
        SET @end = CHARINDEX(@delimiter, @string, @start)
    END 
    RETURN 
END
GO
/****** Object:  UserDefinedFunction [dbo].[geneneraIdLiquida]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[geneneraIdLiquida] (@dato varchar(20) )
returns varchar(12)
begin 
declare @autoincremento int,@numero varchar(8),@codigo varchar(12)
set @codigo=SUBSTRING(@dato,1,4)
select @autoincremento =ISNULL(MAX(CONVERT(INT,RIGHT(LiquidacionNumero,8))),0)FROM Liquidacion
SET @autoincremento=@autoincremento + 1
SELECT @numero=right('0000000' + convert(varchar,@autoincremento),8)
set @codigo=RTRIM(@codigo)+RTRIM(@numero)
return @codigo
end
GO
/****** Object:  UserDefinedFunction [dbo].[geneneraIdLiVenta]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[geneneraIdLiVenta] (@dato varchar(20))
returns varchar(12)
begin 
declare @autoincremento int,@numero varchar(8),@codigo varchar(12)
set @codigo=SUBSTRING(@dato,1,4)
select @autoincremento =ISNULL(MAX(CONVERT(INT,RIGHT(LiquidacionNumero,8))),0)FROM LiquidacionVenta
SET @autoincremento=@autoincremento + 1
SELECT @numero=right('0000000' + convert(varchar,@autoincremento),8)
set @codigo=RTRIM(@codigo)+RTRIM(@numero)
return @codigo
end
GO
/****** Object:  UserDefinedFunction [dbo].[genenerarNroFactura]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[genenerarNroFactura](@dato varchar(20),@CompaniaId int,@DocuDocumento varchar(40))
returns varchar(13)
begin 
declare @autoincremento int,
@numero varchar(8),
@codigo varchar(11)
set @codigo=SUBSTRING(@dato,1,4)
select @autoincremento =ISNULL(MAX(CONVERT(INT,RIGHT(DocuNumero,8))),0)FROM DocumentoVenta
where CompaniaId=@CompaniaId and (DocuDocumento=@DocuDocumento and DocuSerie=@dato)
SET @autoincremento=@autoincremento + 1
SELECT @numero=right('0000000' + convert(varchar,@autoincremento),8)
set @codigo=RTRIM(@numero)
return @codigo
end
GO
/****** Object:  UserDefinedFunction [dbo].[genenerarNroGuia]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[genenerarNroGuia] (@dato varchar(20))
returns varchar(11)
begin 
declare @autoincremento int,@numero varchar(8),@codigo varchar(11)
set @codigo=SUBSTRING(@dato,1,5)
select @autoincremento =ISNULL(MAX(CONVERT(INT,RIGHT(GuiaNumero,6))),0)FROM GuiaRemision
SET @autoincremento=@autoincremento + 1
SELECT @numero=right('00000' + convert(varchar,@autoincremento),6)
set @codigo=RTRIM(@codigo)+RTRIM(@numero)
return @codigo
end
GO
/****** Object:  UserDefinedFunction [dbo].[genenerarNroTicket]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[genenerarNroTicket] (@dato varchar(20))
returns varchar(13)
begin 
declare @autoincremento int,@numero varchar(8),@codigo varchar(13)
set @codigo=SUBSTRING(@dato,1,5)
select @autoincremento =ISNULL(MAX(CONVERT(INT,RIGHT(IdOrden,8))),0)FROM Tbl_Orden_Pedido
SET @autoincremento=@autoincremento + 1
SELECT @numero=right('0000000' + convert(varchar,@autoincremento),8)
set @codigo=RTRIM(@numero)
return @codigo
end
GO
/****** Object:  UserDefinedFunction [dbo].[Letras]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Letras]
(
    @Numero             Decimal(18,2),
    @Moneda             varchar(60)
)
RETURNS Varchar(180)
AS
BEGIN
    DECLARE @RespLetra Varchar(180)
        DECLARE @lnEntero INT,
                        @lcRetorno VARCHAR(512),
                        @lnTerna INT,
                        @lcMiles VARCHAR(512),
                        @lcCadena VARCHAR(512),
                        @lnUnidades INT,
                        @lnDecenas INT,
                        @lnCentenas INT,
                        @lnFraccion INT
        SELECT  @lnEntero = CAST(@Numero AS INT),
                        @lnFraccion = (@Numero - @lnEntero) * 100,
                        @lcRetorno = '',
                        @lnTerna = 1
  WHILE @lnEntero > 0
  BEGIN /* WHILE */
            -- Recorro terna por terna
            SELECT @lcCadena = ''
            SELECT @lnUnidades = @lnEntero % 10
            SELECT @lnEntero = CAST(@lnEntero/10 AS INT)
            SELECT @lnDecenas = @lnEntero % 10
            SELECT @lnEntero = CAST(@lnEntero/10 AS INT)
            SELECT @lnCentenas = @lnEntero % 10
            SELECT @lnEntero = CAST(@lnEntero/10 AS INT)
            -- Analizo las unidades
            SELECT @lcCadena =
            CASE /* UNIDADES */
              WHEN @lnUnidades = 1 THEN 'UN ' + @lcCadena
              WHEN @lnUnidades = 2 THEN 'DOS ' + @lcCadena
              WHEN @lnUnidades = 3 THEN 'TRES ' + @lcCadena
              WHEN @lnUnidades = 4 THEN 'CUATRO ' + @lcCadena
              WHEN @lnUnidades = 5 THEN 'CINCO ' + @lcCadena
              WHEN @lnUnidades = 6 THEN 'SEIS ' + @lcCadena
              WHEN @lnUnidades = 7 THEN 'SIETE ' + @lcCadena
              WHEN @lnUnidades = 8 THEN 'OCHO ' + @lcCadena
              WHEN @lnUnidades = 9 THEN 'NUEVE ' + @lcCadena
              ELSE @lcCadena
            END /* UNIDADES */
            -- Analizo las decenas
            SELECT @lcCadena =
            CASE /* DECENAS */
              WHEN @lnDecenas = 1 THEN
                CASE @lnUnidades
                  WHEN 0 THEN 'DIEZ '
                  WHEN 1 THEN 'ONCE '
                  WHEN 2 THEN 'DOCE '
                  WHEN 3 THEN 'TRECE '
                  WHEN 4 THEN 'CATORCE '
                  WHEN 5 THEN 'QUINCE '
                  WHEN 6 THEN 'DIEZ Y SEIS '
                  WHEN 7 THEN 'DIEZ Y SIETE '
                  WHEN 8 THEN 'DIEZ Y OCHO '
                  WHEN 9 THEN 'DIEZ Y NUEVE '
                END
              WHEN @lnDecenas = 2 THEN
              CASE @lnUnidades
                WHEN 0 THEN 'VEINTE '
                ELSE 'VEINTI' + @lcCadena
              END
              WHEN @lnDecenas = 3 THEN
              CASE @lnUnidades
                WHEN 0 THEN 'TREINTA '
                ELSE 'TREINTA Y ' + @lcCadena
              END
              WHEN @lnDecenas = 4 THEN
                CASE @lnUnidades
                    WHEN 0 THEN 'CUARENTA'
                    ELSE 'CUARENTA Y ' + @lcCadena
                END
              WHEN @lnDecenas = 5 THEN
                CASE @lnUnidades
                    WHEN 0 THEN 'CINCUENTA '
                    ELSE 'CINCUENTA Y ' + @lcCadena
                END
              WHEN @lnDecenas = 6 THEN
                CASE @lnUnidades
                    WHEN 0 THEN 'SESENTA '
                    ELSE 'SESENTA Y ' + @lcCadena
                END
              WHEN @lnDecenas = 7 THEN
                 CASE @lnUnidades
                    WHEN 0 THEN 'SETENTA '
                    ELSE 'SETENTA Y ' + @lcCadena
                 END
              WHEN @lnDecenas = 8 THEN
                CASE @lnUnidades
                    WHEN 0 THEN 'OCHENTA '
                    ELSE  'OCHENTA Y ' + @lcCadena
                END
              WHEN @lnDecenas = 9 THEN
                CASE @lnUnidades
                    WHEN 0 THEN 'NOVENTA '
                    ELSE 'NOVENTA Y ' + @lcCadena
                END
              ELSE @lcCadena
            END /* DECENAS */
            -- Analizo las centenas
            SELECT @lcCadena =
            CASE /* CENTENAS */
			WHEN @lnCentenas = 1 AND @lnTerna = 3 THEN 'CIEN ' + @lcCadena
WHEN @lnCentenas = 1 AND @lnUnidades = 0 AND @lnDecenas = 0 THEN 'CIEN ' + @lcCadena
WHEN @lnCentenas = 1 AND @lnTerna <> 3 THEN 'CIENTO ' + @lcCadena
              WHEN @lnCentenas = 1 THEN 'CIENTO ' + @lcCadena
              WHEN @lnCentenas = 2 THEN 'DOSCIENTOS ' + @lcCadena
              WHEN @lnCentenas = 3 THEN 'TRESCIENTOS ' + @lcCadena
              WHEN @lnCentenas = 4 THEN 'CUATROCIENTOS ' + @lcCadena
              WHEN @lnCentenas = 5 THEN 'QUINIENTOS ' + @lcCadena
              WHEN @lnCentenas = 6 THEN 'SEISCIENTOS ' + @lcCadena
              WHEN @lnCentenas = 7 THEN 'SETECIENTOS ' + @lcCadena
              WHEN @lnCentenas = 8 THEN 'OCHOCIENTOS ' + @lcCadena
              WHEN @lnCentenas = 9 THEN 'NOVECIENTOS ' + @lcCadena
              ELSE @lcCadena
            END /* CENTENAS */
            -- Analizo la terna
            SELECT @lcCadena =
            CASE /* TERNA */
              WHEN @lnTerna = 1 THEN @lcCadena
              WHEN @lnTerna = 2 THEN @lcCadena + 'MIL '
              WHEN @lnTerna = 3 THEN @lcCadena + 'MILLONES '
              WHEN @lnTerna = 4 THEN @lcCadena + 'MIL '
              ELSE ''
            END /* TERNA */
            -- Armo el retorno terna a terna
            SELECT @lcRetorno = @lcCadena  + @lcRetorno
            SELECT @lnTerna = @lnTerna + 1
   END /* WHILE */
   IF @lnTerna = 1
       SELECT @lcRetorno = 'CERO'
   DECLARE @sFraccion VARCHAR(15)
   SET @sFraccion = '00' + LTRIM(CAST(@lnFraccion AS varchar))
   SELECT @RespLetra = RTRIM(@lcRetorno) + ' CON ' + SUBSTRING(@sFraccion,LEN(@sFraccion)-1,2) + '/100 '+@Moneda
   RETURN @RespLetra
END
GO
/****** Object:  UserDefinedFunction [dbo].[MesNombre]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[MesNombre]
(@NroMes int)
returns nvarchar(20)
as
begin
declare @NomMes nvarchar(20)
--set @NroMes=12
	 if (@NroMes=1)set @NomMes='Enero'
	 if (@NroMes=2)set @NomMes='Febreo'
	 if (@NroMes=3)set @NomMes='Marzo'
	 if (@NroMes=4)set @NomMes='Abril'
	 if (@NroMes=5)set @NomMes='Mayo'
	 if (@NroMes=6)set @NomMes='Junio'
	 if (@NroMes=7)set @NomMes='Julio'
	 if (@NroMes=8)set @NomMes='Agosto'
	 if (@NroMes=9)set @NomMes='Septiembre'
	 if (@NroMes=10)set @NomMes='Octubre'
	 if (@NroMes=11)set @NomMes='Noviembre'
	 if (@NroMes=12)set @NomMes='Diciembre'
 return @NomMes
end
GO
/****** Object:  Table [dbo].[Almacen]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Almacen](
	[AlmacenId] [numeric](20, 0) IDENTITY(1,1) NOT NULL,
	[AlmacenNombre] [varchar](80) NULL,
	[AlmacenDepartamento] [varchar](80) NULL,
	[AlmacenProvincia] [varchar](80) NULL,
	[AlmacenDistrito] [varchar](80) NULL,
	[AlmacenDireccion] [varchar](300) NULL,
	[AlmacenEstado] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[AlmacenId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AperturaInsumos]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AperturaInsumos](
	[IdApertura] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[FechaApertura] [date] NULL,
	[FechaCierre] [datetime] NULL,
	[Usuario] [varchar](80) NULL,
	[Estado] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdApertura] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Area]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Area](
	[AreaId] [numeric](20, 0) IDENTITY(1,1) NOT NULL,
	[AreaNombre] [varchar](80) NULL,
PRIMARY KEY CLUSTERED 
(
	[AreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Asistencia]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Asistencia](
	[Id] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[Fecha] [date] NULL,
	[PersonalId] [numeric](20, 0) NULL,
	[HoraIngreso] [datetime] NULL,
	[SalidaRefrigerio] [datetime] NULL,
	[IngresoRefrigerio] [datetime] NULL,
	[HoraSalida] [datetime] NULL,
	[NroMarcacion] [int] NULL,
	[Observaciones] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BLOQUE]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BLOQUE](
	[BloqueId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[BloqueCaja] [numeric](38, 0) NULL,
	[BloqueFecha] [datetime] NULL,
	[BloqueTotal] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[BloqueId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Caja]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Caja](
	[CajaId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[CajaFecha] [datetime] NULL,
	[CajaCierre] [varchar](40) NULL,
	[MontoIniSOl] [decimal](18, 2) NULL,
	[CajaEncargado] [varchar](60) NULL,
	[CajaUsuario] [varchar](60) NULL,
	[CajaEstado] [varchar](40) NULL,
	[CajaIngresos] [decimal](18, 2) NULL,
	[CajaDeposito] [decimal](18, 2) NULL,
	[CajaSalidas] [decimal](18, 2) NULL,
	[CajaTotal] [decimal](18, 2) NULL,
	[UsuarioId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CajaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CajaDetalle]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CajaDetalle](
	[DetalleId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[CajaId] [numeric](38, 0) NULL,
	[DetalleFecha] [datetime] NULL,
	[NotaId] [numeric](38, 0) NULL,
	[DetalleMovimiento] [varchar](80) NULL,
	[DetalleReferencia] [varchar](80) NULL,
	[DetalleConcepto] [varchar](250) NULL,
	[DetalleMoneda] [varchar](40) NULL,
	[DetalleTipoCambio] [decimal](18, 2) NULL,
	[DetalleMonto] [decimal](18, 2) NULL,
	[DetalleEfectivo] [decimal](18, 2) NULL,
	[DetalleVuelto] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[DetalleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CajaGeneral]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CajaGeneral](
	[IdGeneral] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[FechaCierre] [datetime] NULL,
	[Usuario] [varchar](80) NULL,
	[Ingresos] [decimal](18, 2) NULL,
	[Salidas] [decimal](18, 2) NULL,
	[Total] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdGeneral] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CajaPincipal]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CajaPincipal](
	[IdCaja] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[CajaConcepto] [varchar](80) NULL,
	[CajaFecha] [datetime] NULL,
	[CajaId] [numeric](38, 0) NULL,
	[CajaDescripcion] [varchar](250) NULL,
	[CajaMonto] [decimal](18, 2) NULL,
	[CajaUsuario] [varchar](20) NULL,
	[IdGeneral] [numeric](38, 0) NULL,
	[RutaImagen] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdCaja] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cliente]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cliente](
	[ClienteId] [numeric](20, 0) IDENTITY(1,1) NOT NULL,
	[ClienteRazon] [varchar](140) NULL,
	[ClienteRuc] [varchar](40) NULL,
	[ClienteDni] [varchar](40) NULL,
	[ClienteDireccion] [varchar](max) NULL,
	[ClienteMovil] [varchar](80) NULL,
	[ClienteTelefono] [varchar](80) NULL,
	[ClienteCorreo] [varchar](80) NULL,
	[ClienteEstado] [varchar](40) NULL,
	[ClienteDespacho] [varchar](max) NULL,
	[ClienteUsuario] [varchar](80) NULL,
	[ClienteFecha] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ClienteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Combinacion_Mesas]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Combinacion_Mesas](
	[Id] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[IdOrden] [numeric](38, 0) NULL,
	[id_mesa] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Compania]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Compania](
	[CompaniaId] [int] IDENTITY(1,1) NOT NULL,
	[CompaniaRazonSocial] [varchar](140) NULL,
	[CompaniaRUC] [varchar](20) NULL,
	[CompaniaDireccion] [varchar](max) NULL,
	[CompaniaTelefono] [varchar](80) NULL,
	[CompaniaEmail] [varchar](100) NULL,
	[CompaniaIniFecha] [varchar](100) NULL,
	[CompaniaComercial] [varchar](250) NULL,
	[CompaniaUserSecun] [varchar](250) NULL,
	[ComapaniaPWD] [varchar](250) NULL,
	[CompaniaPFX] [varchar](250) NULL,
	[CompaniaClave] [varchar](250) NULL,
	[CompaniaNomUBG] [varchar](40) NULL,
	[CompaniaCodigoUBG] [varchar](10) NULL,
	[CompaniaDistrito] [varchar](40) NULL,
	[CompaniaDirecSunat] [varchar](250) NULL,
	[TokenApi] [varchar](max) NULL,
	[ClienIdToken] [varchar](max) NULL,
	[ICBPER] [decimal](18, 2) NULL,
	[RenovacionFirma] [date] NULL,
	[IGV] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[CompaniaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Compras]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Compras](
	[CompraId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[CompaniaId] [int] NULL,
	[CompraCorrelativo] [varchar](80) NULL,
	[ProveedorId] [numeric](38, 0) NULL,
	[CompraRegistro] [datetime] NULL,
	[CompraEmision] [date] NULL,
	[CompraComputo] [date] NULL,
	[TipoCodigo] [char](20) NULL,
	[CompraSerie] [varchar](60) NULL,
	[CompraNumero] [varchar](80) NULL,
	[CompraCondicion] [varchar](60) NULL,
	[CompraMoneda] [varchar](60) NULL,
	[CompraTipoCambio] [decimal](18, 3) NULL,
	[CompraDias] [int] NULL,
	[CompraFechaPago] [date] NULL,
	[CompraUsuario] [varchar](80) NULL,
	[CompraTipoIgv] [varchar](60) NULL,
	[CompraValorVenta] [decimal](18, 2) NULL,
	[CompraDescuento] [decimal](18, 2) NULL,
	[CompraSubtotal] [decimal](18, 2) NULL,
	[CompraIgv] [decimal](18, 2) NULL,
	[CompraTotal] [decimal](18, 2) NULL,
	[CompraEstado] [varchar](60) NULL,
	[CompraAsociado] [varchar](60) NULL,
	[CompraSaldo] [decimal](18, 2) NULL,
	[CompraOBS] [varchar](max) NULL,
	[CompraTipoSunat] [decimal](18, 3) NULL,
	[CompraConcepto] [varchar](60) NULL,
	[CompraPercepcion] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[CompraId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CuentaProveedor]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CuentaProveedor](
	[CuentaId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[ProveedorId] [numeric](38, 0) NULL,
	[Entidad] [varchar](80) NULL,
	[TipoCuenta] [varchar](80) NULL,
	[Moneda] [varchar](80) NULL,
	[NroCuenta] [varchar](80) NULL,
PRIMARY KEY CLUSTERED 
(
	[CuentaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetaLiquidaVenta]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetaLiquidaVenta](
	[DetalleId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[LiquidacionId] [numeric](38, 0) NULL,
	[DocuId] [numeric](38, 0) NULL,
	[NotaId] [numeric](38, 0) NULL,
	[SaldoDocu] [decimal](18, 2) NULL,
	[EfectivoSoles] [decimal](18, 2) NULL,
	[EfectivoDolar] [decimal](18, 2) NULL,
	[DepositoSoles] [decimal](18, 2) NULL,
	[DepositoDolar] [decimal](18, 2) NULL,
	[TipoCambio] [decimal](18, 3) NULL,
	[EntidadBanco] [varchar](80) NULL,
	[NroOperacion] [varchar](80) NULL,
	[AcuentaGeneral] [decimal](18, 2) NULL,
	[SaldoActual] [decimal](18, 2) NULL,
	[FechaPago] [varchar](60) NULL,
PRIMARY KEY CLUSTERED 
(
	[DetalleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetalleApertura]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleApertura](
	[DetalleId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[IdApertura] [numeric](38, 0) NULL,
	[Descripcion] [varchar](max) NULL,
	[Ingreso] [decimal](18, 3) NULL,
	[DeIngreso] [varchar](10) NULL,
	[Cierre] [decimal](18, 3) NULL,
	[DeCierre] [varchar](10) NULL,
	[Total] [varchar](80) NULL,
PRIMARY KEY CLUSTERED 
(
	[DetalleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetalleBloque]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleBloque](
	[DetalleId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[BloqueId] [numeric](38, 0) NULL,
	[NotaId] [numeric](38, 0) NULL,
PRIMARY KEY CLUSTERED 
(
	[DetalleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetalleCompra]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleCompra](
	[DetalleId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[CompraId] [numeric](38, 0) NULL,
	[IdProducto] [numeric](20, 0) NULL,
	[DetalleCodigo] [varchar](80) NULL,
	[Descripcion] [varchar](255) NULL,
	[DetalleUM] [varchar](60) NULL,
	[DetalleCantidad] [decimal](18, 2) NULL,
	[PrecioCosto] [decimal](18, 4) NULL,
	[DetalleImporte] [decimal](18, 4) NULL,
	[DetalleDescuento] [decimal](18, 4) NULL,
	[DetalleEstado] [varchar](40) NULL,
	[DescuentoB] [decimal](18, 4) NULL,
	[EstadoB] [char](1) NULL,
	[ValorUM] [decimal](18, 4) NULL,
PRIMARY KEY CLUSTERED 
(
	[DetalleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetalleDocumento]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleDocumento](
	[DetalleId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[DocuId] [numeric](38, 0) NULL,
	[IdProducto] [numeric](20, 0) NULL,
	[DetalleCantidad] [decimal](18, 2) NULL,
	[DetallPrecio] [decimal](18, 2) NULL,
	[DetalleImporte] [decimal](18, 2) NULL,
	[DetalleNotaId] [numeric](38, 0) NULL,
	[DetalleUM] [varchar](80) NULL,
	[ValorUM] [decimal](18, 4) NULL,
PRIMARY KEY CLUSTERED 
(
	[DetalleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetalleGuia]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleGuia](
	[DetalleId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[GuiaId] [numeric](38, 0) NULL,
	[IdProducto] [numeric](20, 0) NULL,
	[DetalleCantidad] [decimal](18, 2) NULL,
	[DetalleCosto] [decimal](18, 4) NULL,
	[DetallePrecio] [decimal](18, 2) NULL,
	[DetalleImporte] [decimal](18, 2) NULL,
	[DetalleEstado] [varchar](60) NULL,
	[IdDetalle] [numeric](38, 0) NULL,
	[ValorUM] [decimal](18, 4) NULL,
	[UniMedida] [varchar](40) NULL,
PRIMARY KEY CLUSTERED 
(
	[DetalleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetalleLetra]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleLetra](
	[DetalleId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[LetraId] [numeric](38, 0) NULL,
	[LetraCanje] [varchar](80) NULL,
	[LetraDias] [int] NULL,
	[LetraVencimiento] [date] NULL,
	[DetalleSaldo] [decimal](18, 2) NULL,
	[DetalleMonto] [decimal](18, 2) NULL,
	[DetalleEstado] [varchar](60) NULL,
PRIMARY KEY CLUSTERED 
(
	[DetalleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetalleLiquida]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleLiquida](
	[DetalleId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[LiquidacionId] [numeric](38, 0) NULL,
	[CompraId] [numeric](38, 0) NULL,
	[SaldoDocu] [decimal](18, 2) NULL,
	[EfectivoSoles] [decimal](18, 2) NULL,
	[EfectivoDolar] [decimal](18, 2) NULL,
	[DepositoSoles] [decimal](18, 2) NULL,
	[DepositoDolar] [decimal](18, 2) NULL,
	[TipoCambio] [decimal](18, 3) NULL,
	[EntidadBanco] [varchar](80) NULL,
	[NroOperacion] [varchar](80) NULL,
	[AcuentaGeneral] [decimal](18, 2) NULL,
	[SaldoActual] [decimal](18, 2) NULL,
	[FechaPago] [varchar](60) NULL,
	[Numero] [varchar](60) NULL,
	[Proveedor] [varchar](255) NULL,
	[Moneda] [varchar](20) NULL,
	[Concepto] [varchar](40) NULL,
PRIMARY KEY CLUSTERED 
(
	[DetalleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetalleNube]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleNube](
	[DetalleId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[DocuId] [numeric](38, 0) NULL,
	[IdProducto] [numeric](20, 0) NULL,
	[ProductoCodigo] [varchar](300) NULL,
	[Descripcion] [varchar](max) NULL,
	[DetalleCantidad] [decimal](18, 2) NULL,
	[DetalleUM] [varchar](80) NULL,
	[DetallPrecio] [decimal](18, 2) NULL,
	[DetalleImporte] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[DetalleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetallePedido]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetallePedido](
	[DetalleId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[NotaId] [numeric](38, 0) NULL,
	[IdProducto] [numeric](20, 0) NULL,
	[DetalleCantidad] [decimal](18, 2) NULL,
	[DetalleUm] [varchar](40) NULL,
	[DetalleDescripcion] [varchar](140) NULL,
	[DetalleCosto] [decimal](18, 2) NULL,
	[DetallePrecio] [decimal](18, 2) NULL,
	[DetalleImporte] [decimal](18, 2) NULL,
	[DetalleEstado] [varchar](60) NULL,
	[CantidadSaldo] [decimal](18, 2) NULL,
	[ValorUM] [decimal](18, 4) NULL,
PRIMARY KEY CLUSTERED 
(
	[DetalleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DocumentoCanje]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DocumentoCanje](
	[DocumentoId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[LetraId] [numeric](38, 0) NULL,
	[CompraId] [numeric](38, 0) NULL,
	[Documento] [varchar](60) NULL,
	[Moneda] [varchar](60) NULL,
	[Monto] [varchar](80) NULL,
PRIMARY KEY CLUSTERED 
(
	[DocumentoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DocumentoVenta]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DocumentoVenta](
	[DocuId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[CompaniaId] [int] NULL,
	[NotaId] [numeric](38, 0) NULL,
	[DocuDocumento] [varchar](60) NULL,
	[DocuNumero] [varchar](60) NULL,
	[ClienteId] [numeric](20, 0) NULL,
	[DocuRegistro] [datetime] NULL,
	[DocuEmision] [date] NULL,
	[DocuCondicion] [varchar](60) NULL,
	[DocuFechaPago] [date] NULL,
	[DocuLetras] [varchar](60) NULL,
	[DocuSubTotal] [decimal](18, 2) NULL,
	[DocuIgv] [decimal](18, 2) NULL,
	[DocuTotal] [decimal](18, 2) NULL,
	[DocuSaldo] [decimal](18, 2) NULL,
	[DocuUsuario] [varchar](60) NULL,
	[DocuEstado] [varchar](60) NULL,
	[DocuSerie] [char](4) NULL,
	[TipoCodigo] [char](20) NULL,
	[DocuAdicional] [decimal](18, 2) NULL,
	[DocuAsociado] [varchar](80) NULL,
	[DocuConcepto] [varchar](80) NULL,
	[DocuNroGuia] [varchar](80) NULL,
	[DocuHash] [varchar](250) NULL,
	[EstadoSunat] [varchar](80) NULL,
	[CodigoSunat] [varchar](80) NULL,
	[MensajeSunat] [varchar](max) NULL,
	[ICBPER] [decimal](18, 2) NULL,
	[DocuGravada] [decimal](18, 2) NULL,
	[DocuDescuento] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[DocuId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GastosFijos]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GastosFijos](
	[GastoId] [int] IDENTITY(1,1) NOT NULL,
	[GastoFecha] [date] NULL,
	[GsstoDesc] [varchar](max) NULL,
	[GstoMonto] [decimal](18, 2) NULL,
	[GastoReg] [datetime] NULL,
	[GastoUsuario] [varchar](80) NULL,
PRIMARY KEY CLUSTERED 
(
	[GastoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GuiaCanje]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GuiaCanje](
	[CanjeId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[CompraId] [numeric](38, 0) NULL,
	[CompaniaId] [int] NULL,
	[CanjeFecha] [date] NULL,
	[CanjeRegistro] [datetime] NULL,
	[CanjeSerie] [varchar](80) NULL,
	[CanjeNumero] [varchar](80) NULL,
	[CanjeEmision] [date] NULL,
	[CanjeComputo] [date] NULL,
	[CanjeCorrelativo] [varchar](80) NULL,
	[CanjeTipo] [varchar](80) NULL,
	[CanjeOBS] [varchar](max) NULL,
	[TCSunat] [decimal](18, 3) NULL,
	[GCompania] [int] NULL,
	[GSerie] [varchar](80) NULL,
	[GNumero] [varchar](80) NULL,
	[GEmision] [date] NULL,
	[GCanjeComputo] [date] NULL,
	[GCanjeCorrelativo] [varchar](80) NULL,
	[GCanjeTipo] [varchar](80) NULL,
	[GCanjeOBS] [varchar](max) NULL,
	[GTCSunat] [decimal](18, 3) NULL,
	[CanjeUsuario] [varchar](60) NULL,
PRIMARY KEY CLUSTERED 
(
	[CanjeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GuiaRelacion]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GuiaRelacion](
	[DetalleId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[GuiaId] [numeric](38, 0) NULL,
	[NotaId] [numeric](38, 0) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GuiaRemision]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GuiaRemision](
	[GuiaId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[GuiaNumero] [varchar](60) NULL,
	[GuiaMotivo] [varchar](80) NULL,
	[GuiaRegistro] [datetime] NULL,
	[GuiaFechaTraslado] [datetime] NULL,
	[GuiaDestinatario] [varchar](250) NULL,
	[GuiaRucDes] [varchar](60) NULL,
	[GuiaAlmacen] [varchar](80) NULL,
	[GuiaPartida] [varchar](max) NULL,
	[GuiaLLegada] [varchar](max) NULL,
	[GuiaTramsporte] [varchar](80) NULL,
	[GuiaTransporteRuc] [varchar](20) NULL,
	[GuiaChofer] [varchar](80) NULL,
	[GuiaPlaca] [varchar](80) NULL,
	[GuiaConstancia] [varchar](80) NULL,
	[GuiaLicencia] [varchar](80) NULL,
	[GuiaUsuario] [varchar](80) NULL,
	[GuiaTotal] [decimal](18, 2) NULL,
	[GuiaConcepto] [varchar](40) NULL,
	[ClienteId] [numeric](20, 0) NULL,
	[GuiaEstado] [varchar](60) NULL,
	[GuiaTelefono] [varchar](80) NULL,
PRIMARY KEY CLUSTERED 
(
	[GuiaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Kardex]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Kardex](
	[KardexId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[IdProducto] [numeric](20, 0) NULL,
	[KardexFecha] [datetime] NULL,
	[KardexMotivo] [varchar](60) NULL,
	[KardexDocumento] [varchar](60) NULL,
	[StockInicial] [decimal](18, 2) NULL,
	[CantidadIngreso] [decimal](18, 2) NULL,
	[CantidadSalida] [decimal](18, 2) NULL,
	[PrecioCosto] [decimal](18, 4) NULL,
	[StockFinal] [decimal](18, 2) NULL,
	[KadexConcepto] [varchar](40) NULL,
	[Usuario] [varchar](60) NULL,
PRIMARY KEY CLUSTERED 
(
	[KardexId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Letra]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Letra](
	[LetraId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[ProveedorId] [numeric](38, 0) NULL,
	[LetraFechaReg] [datetime] NULL,
	[LetraFechaGiro] [date] NULL,
	[LetraMoneda] [varchar](40) NULL,
	[LetraSaldo] [decimal](18, 2) NULL,
	[LetraTotal] [decimal](18, 2) NULL,
	[LetraUsuario] [varchar](60) NULL,
	[LetraEstado] [varchar](60) NULL,
	[CompaniaId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[LetraId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Linea]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Linea](
	[IdLinea] [numeric](20, 0) IDENTITY(1,1) NOT NULL,
	[NombreLinea] [varchar](300) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdLinea] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Liquidacion]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Liquidacion](
	[LiquidacionId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[LiquidacionNumero] [varchar](80) NULL,
	[LiquidacionRegistro] [datetime] NULL,
	[LiquidacionFecha] [date] NULL,
	[LiquidacionDescripcion] [varchar](250) NULL,
	[LiquidacionCambio] [decimal](18, 3) NULL,
	[LiquidaEfectivoSol] [decimal](18, 2) NULL,
	[LiquidaDepositoSol] [decimal](18, 2) NULL,
	[LiquidaTotalSol] [decimal](18, 2) NULL,
	[LiquidaEfectivoDol] [decimal](18, 2) NULL,
	[LiquidaDepositoDol] [decimal](18, 2) NULL,
	[LiquidaTotalDol] [decimal](18, 2) NULL,
	[LiquidaUsuario] [varchar](60) NULL,
PRIMARY KEY CLUSTERED 
(
	[LiquidacionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LiquidacionVenta]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LiquidacionVenta](
	[LiquidacionId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[LiquidacionNumero] [varchar](80) NULL,
	[LiquidacionRegistro] [datetime] NULL,
	[LiquidacionFecha] [date] NULL,
	[LiquidacionDescripcion] [varchar](250) NULL,
	[LiquidacionCambio] [decimal](18, 3) NULL,
	[LiquidaEfectivoSol] [decimal](18, 2) NULL,
	[LiquidaDepositoSol] [decimal](18, 2) NULL,
	[LiquidaTotalSol] [decimal](18, 2) NULL,
	[LiquidaEfectivoDol] [decimal](18, 2) NULL,
	[LiquidaDepositoDol] [decimal](18, 2) NULL,
	[LiquidaTotalDol] [decimal](18, 2) NULL,
	[LiquidaUsuario] [varchar](60) NULL,
PRIMARY KEY CLUSTERED 
(
	[LiquidacionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NotaPedido]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotaPedido](
	[NotaId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[NotaDocu] [varchar](60) NULL,
	[ClienteId] [numeric](20, 0) NULL,
	[NotaFecha] [datetime] NULL,
	[NotaUsuario] [varchar](60) NULL,
	[NotaFormaPago] [varchar](60) NULL,
	[NotaCondicion] [varchar](60) NULL,
	[NotaDias] [int] NULL,
	[NotaFechaPago] [date] NULL,
	[NotaDireccion] [varchar](max) NULL,
	[NotaTelefono] [varchar](250) NULL,
	[NotaSubtotal] [decimal](18, 2) NULL,
	[NotaMovilidad] [decimal](18, 2) NULL,
	[NotaDescuento] [decimal](18, 2) NULL,
	[NotaTotal] [decimal](18, 2) NULL,
	[NotaAcuenta] [decimal](18, 2) NULL,
	[NotaSaldo] [decimal](18, 2) NULL,
	[NotaAdicional] [decimal](18, 2) NULL,
	[NotaTarjeta] [decimal](18, 2) NULL,
	[NotaPagar] [decimal](18, 2) NULL,
	[NotaEstado] [varchar](60) NULL,
	[CompaniaId] [int] NULL,
	[NotaEntrega] [varchar](40) NULL,
	[ModificadoPor] [varchar](60) NULL,
	[FechaEdita] [varchar](60) NULL,
	[NotaConcepto] [varchar](60) NULL,
	[NotaSerie] [varchar](60) NULL,
	[NotaNumero] [varchar](60) NULL,
	[NotaGanancia] [decimal](18, 2) NULL,
	[CajaId] [numeric](38, 0) NULL,
	[NotaEfectivo] [decimal](18, 2) NULL,
	[NotaVuelto] [decimal](18, 2) NULL,
	[ICBPER] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[NotaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NubeDocumento]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NubeDocumento](
	[Id] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[DocuId] [numeric](38, 0) NULL,
	[CompaniaId] [int] NULL,
	[NotaId] [numeric](38, 0) NULL,
	[Emision] [date] NULL,
	[Documento] [varchar](60) NULL,
	[Numero] [varchar](60) NULL,
	[ClienteRazon] [varchar](max) NULL,
	[ClienteRUC] [varchar](20) NULL,
	[ClienteDNI] [varchar](20) NULL,
	[DireccionFiscal] [varchar](max) NULL,
	[DireccionDespacho] [varchar](max) NULL,
	[Total] [decimal](18, 2) NULL,
	[Usuario] [varchar](60) NULL,
	[Estado] [varchar](60) NULL,
	[FechaEnvio] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Personal]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Personal](
	[PersonalId] [numeric](20, 0) IDENTITY(1,1) NOT NULL,
	[PersonalNombres] [varchar](140) NULL,
	[PersonalApellidos] [varchar](140) NULL,
	[AreaId] [numeric](20, 0) NULL,
	[PersonalCodigo] [varchar](80) NULL,
	[PersonalNacimiento] [date] NULL,
	[PersonalIngreso] [varchar](20) NULL,
	[PersonalDNI] [varchar](20) NULL,
	[PersonalDireccion] [varchar](140) NULL,
	[PersonalTelefono] [varchar](40) NULL,
	[PersonalTelefonoAsi] [varchar](40) NULL,
	[PersonalEmail] [varchar](100) NULL,
	[PersonalSueldo] [decimal](18, 2) NULL,
	[PersonalEstado] [varchar](60) NULL,
	[PersonalBajaFecha] [varchar](60) NULL,
	[PersonalRuc] [varchar](20) NULL,
	[PersonalImagen] [varchar](max) NULL,
	[CompaniaId] [int] NULL,
	[HUELLA] [image] NULL,
	[HoraIngreso] [time](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[PersonalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Producto]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Producto](
	[IdProducto] [numeric](20, 0) IDENTITY(1,1) NOT NULL,
	[IdSubLinea] [numeric](20, 0) NULL,
	[ProductoCodigo] [varchar](300) NULL,
	[ProductoNombre] [varchar](300) NULL,
	[ProductoUM] [varchar](60) NULL,
	[ProductoCosto] [decimal](18, 4) NULL,
	[ProductoVenta] [decimal](18, 2) NULL,
	[ProductoVentaB] [decimal](18, 2) NULL,
	[ProductoCantidad] [decimal](18, 2) NULL,
	[ProductoObs] [varchar](300) NULL,
	[ProductoEstado] [varchar](60) NULL,
	[ProductoUsuario] [varchar](60) NULL,
	[ProductoFecha] [datetime] NULL,
	[ProductoImagen] [varchar](max) NULL,
	[ValorCritico] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdProducto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Proveedor]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Proveedor](
	[ProveedorId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[ProveedorRazon] [varchar](250) NULL,
	[ProveedorRuc] [varchar](20) NULL,
	[ProveedorContacto] [varchar](140) NULL,
	[ProveedorCelular] [varchar](140) NULL,
	[ProveedorTelefono] [varchar](140) NULL,
	[ProveedorCorreo] [varchar](140) NULL,
	[ProveedorDireccion] [varchar](140) NULL,
	[ProveedorEstado] [varchar](40) NULL,
PRIMARY KEY CLUSTERED 
(
	[ProveedorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RentaMensual]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RentaMensual](
	[RentaId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[CompaniaId] [int] NULL,
	[RentaUsuario] [varchar](80) NULL,
	[RentaANNO] [int] NULL,
	[RentaMes] [int] NULL,
	[IGV] [decimal](18, 2) NULL,
	[Renta] [decimal](18, 2) NULL,
	[SaldoIGV] [decimal](18, 2) NULL,
	[SaldoRenta] [decimal](18, 2) NULL,
	[InteresIgv] [decimal](18, 2) NULL,
	[InteresRenta] [decimal](18, 2) NULL,
	[TributoIgv] [decimal](18, 2) NULL,
	[TributoRenta] [decimal](18, 2) NULL,
	[FormaPago] [bit] NULL,
	[FechaCancelacion] [date] NULL,
	[EntidadBancaria] [varchar](80) NULL,
	[NroOperacion] [varchar](80) NULL,
	[PagoTotal] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[RentaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ResumenBoletas]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResumenBoletas](
	[ResumenId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[CompaniaId] [int] NULL,
	[ResumenSerie] [varchar](250) NULL,
	[Secuencia] [numeric](38, 0) NULL,
	[FechaReferencia] [date] NULL,
	[FechaEnvio] [datetime] NULL,
	[SubTotal] [decimal](18, 2) NULL,
	[IGV] [decimal](18, 2) NULL,
	[Total] [decimal](18, 2) NULL,
	[ResumenTiket] [varchar](250) NULL,
	[CodigoSunat] [varchar](80) NULL,
	[HASHCDR] [varchar](max) NULL,
	[MensajeSunat] [varchar](max) NULL,
	[Usuario] [varchar](80) NULL,
	[ESTADO] [char](1) NULL,
	[RangoNumero] [varchar](80) NULL,
	[ICBPER] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[ResumenId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sublinea]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sublinea](
	[IdSubLinea] [numeric](20, 0) IDENTITY(1,1) NOT NULL,
	[IdLinea] [numeric](20, 0) NULL,
	[NombreSublinea] [varchar](300) NULL,
	[CodigoSunat] [varchar](40) NULL,
	[EnviarIMP] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdSubLinea] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tbl_Detalle_Orden]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tbl_Detalle_Orden](
	[DetalleId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[IdOrden] [numeric](38, 0) NULL,
	[IdProducto] [numeric](20, 0) NULL,
	[Cantidad] [decimal](18, 2) NULL,
	[PrecioUni] [decimal](18, 2) NULL,
	[Importe] [decimal](18, 2) NULL,
	[Estado] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[DetalleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_mesa]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_mesa](
	[id_mesa] [int] IDENTITY(1,1) NOT NULL,
	[nro_mesa] [nvarchar](50) NULL,
	[capacidad] [int] NULL,
	[ubicacion] [nvarchar](20) NULL,
	[estado] [nvarchar](15) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_mesa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tbl_Orden_Pedido]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tbl_Orden_Pedido](
	[IdOrden] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[ClienteId] [numeric](20, 0) NULL,
	[FechaOrden] [datetime] NULL,
	[HoraFin] [datetime] NULL,
	[OrdenSerie] [char](4) NULL,
	[OrdenNumero] [varchar](40) NULL,
	[NroMesas] [varchar](80) NULL,
	[Observaciones] [varchar](300) NULL,
	[Usuario] [varchar](80) NULL,
	[Total] [decimal](18, 2) NULL,
	[Estado] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdOrden] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TemporalCanje]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TemporalCanje](
	[temporalId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[temporalCanje] [varchar](80) NULL,
	[temporalDias] [int] NULL,
	[temporalVencimiento] [varchar](20) NULL,
	[temporalMonto] [decimal](18, 2) NULL,
	[usuarioId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[temporalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TemporalCompra]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TemporalCompra](
	[TemporalId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[UsuarioID] [int] NULL,
	[IdProducto] [numeric](20, 0) NULL,
	[DetalleCodigo] [varchar](80) NULL,
	[Descripcion] [varchar](255) NULL,
	[DetalleUM] [varchar](60) NULL,
	[DetalleCantidad] [decimal](18, 2) NULL,
	[PrecioCosto] [decimal](18, 4) NULL,
	[DetalleImporte] [decimal](18, 2) NULL,
	[DetalleDescuento] [decimal](18, 4) NULL,
	[DetalleEstado] [varchar](40) NULL,
	[ValorUM] [decimal](18, 4) NULL,
PRIMARY KEY CLUSTERED 
(
	[TemporalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TemporalGuia]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TemporalGuia](
	[TemporalId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[UsuarioID] [int] NULL,
	[IdProducto] [numeric](20, 0) NULL,
	[cantidad] [decimal](18, 2) NULL,
	[precioventa] [decimal](18, 2) NULL,
	[importe] [decimal](18, 2) NULL,
	[Concepto] [varchar](60) NULL,
	[CantidadSaldo] [decimal](18, 2) NULL,
	[ClienteId] [numeric](20, 0) NULL,
	[DetalleId] [numeric](38, 0) NULL,
	[DetalleUM] [varchar](40) NULL,
	[ValorUM] [decimal](18, 4) NULL,
PRIMARY KEY CLUSTERED 
(
	[TemporalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[temporalLetra]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[temporalLetra](
	[TemporalId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[CompraId] [numeric](38, 0) NULL,
	[ProveedorId] [numeric](38, 0) NULL,
	[TemporalDocumento] [varchar](60) NULL,
	[TemporalMoneda] [varchar](20) NULL,
	[TemporalMonto] [decimal](18, 2) NULL,
	[UsuarioId] [int] NULL,
	[TemporalCanje] [varchar](80) NULL,
PRIMARY KEY CLUSTERED 
(
	[TemporalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TemporalLiquida]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TemporalLiquida](
	[TemporalId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[IdDeuda] [numeric](38, 0) NULL,
	[Numero] [varchar](60) NULL,
	[Proveedor] [varchar](255) NULL,
	[SaldoDocu] [decimal](18, 2) NULL,
	[Moneda] [varchar](20) NULL,
	[TipoCambio] [decimal](18, 3) NULL,
	[EfectivoSoles] [decimal](18, 2) NULL,
	[EfectivoDolar] [decimal](18, 2) NULL,
	[DepositoSoles] [decimal](18, 2) NULL,
	[DepositoDolar] [decimal](18, 2) NULL,
	[EntidadBanco] [varchar](80) NULL,
	[NroOperacion] [varchar](80) NULL,
	[AcuentaGeneral] [decimal](18, 2) NULL,
	[TemporalFecha] [varchar](60) NULL,
	[UsuarioId] [int] NULL,
	[Concepto] [varchar](40) NULL,
PRIMARY KEY CLUSTERED 
(
	[TemporalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TemporalLiVenta]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TemporalLiVenta](
	[TemporalId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[DocuId] [numeric](38, 0) NULL,
	[NotaId] [numeric](38, 0) NULL,
	[UsuarioId] [int] NULL,
	[SaldoDocu] [decimal](18, 2) NULL,
	[TipoCambio] [decimal](18, 3) NULL,
	[EfectivoSoles] [decimal](18, 2) NULL,
	[EfectivoDolar] [decimal](18, 2) NULL,
	[DepositoSoles] [decimal](18, 2) NULL,
	[DepositoDolar] [decimal](18, 2) NULL,
	[EntidadBanco] [varchar](80) NULL,
	[NroOperacion] [varchar](80) NULL,
	[AcuentaGeneral] [decimal](18, 2) NULL,
	[TemporalFecha] [varchar](60) NULL,
PRIMARY KEY CLUSTERED 
(
	[TemporalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TemporalServicio]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TemporalServicio](
	[TemporalId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[UsuarioId] [int] NULL,
	[TemporalDetalle] [varchar](max) NULL,
	[TemporalUm] [varchar](80) NULL,
	[TemporalCantidad] [decimal](18, 2) NULL,
	[TemporalCosto] [decimal](18, 4) NULL,
	[TemporalDescuento] [decimal](18, 4) NULL,
	[TemporalImporte] [decimal](18, 2) NULL,
	[TemporalEstado] [varchar](80) NULL,
PRIMARY KEY CLUSTERED 
(
	[TemporalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TemporalVenta]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TemporalVenta](
	[temporalId] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[UsuarioID] [int] NULL,
	[IdProducto] [numeric](20, 0) NULL,
	[cantidad] [decimal](18, 2) NULL,
	[precioventa] [decimal](18, 2) NULL,
	[importe] [decimal](18, 2) NULL,
	[ValorUM] [decimal](18, 4) NULL,
	[UniMedida] [varchar](40) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoCambio]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoCambio](
	[IdTipo] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[TipoFecha] [date] NULL,
	[TipoCompra] [decimal](18, 3) NULL,
	[TipoVenta] [decimal](18, 3) NULL,
	[TipoEmpresa] [decimal](18, 3) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdTipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoComprobante]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoComprobante](
	[TipoId] [int] IDENTITY(1,1) NOT NULL,
	[TipoCodigo] [char](20) NULL,
	[TipoDescripcion] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[TipoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ubigeo]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ubigeo](
	[UgeoId] [int] IDENTITY(1,1) NOT NULL,
	[IdDepa] [varchar](20) NULL,
	[IdProv] [varchar](20) NULL,
	[IdDist] [varchar](20) NULL,
	[Nombre] [varchar](140) NULL,
PRIMARY KEY CLUSTERED 
(
	[UgeoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UnidadMedida]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UnidadMedida](
	[IdUm] [int] IDENTITY(1,1) NOT NULL,
	[IdProducto] [numeric](20, 0) NULL,
	[UMDescripcion] [varchar](80) NULL,
	[ValorUM] [decimal](18, 4) NULL,
	[PrecioVenta] [decimal](18, 2) NULL,
	[PrecioVentaB] [decimal](18, 2) NULL,
	[PrecioCosto] [decimal](18, 4) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdUm] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuarios]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuarios](
	[UsuarioID] [int] IDENTITY(1,1) NOT NULL,
	[PersonalId] [numeric](20, 0) NULL,
	[UsuarioAlias] [varchar](60) NULL,
	[UsuarioClave] [varbinary](500) NULL,
	[UsuarioFechaReg] [datetime] NULL,
	[UsuarioEstado] [varchar](40) NULL,
	[UsuarioSerie] [varchar](4) NULL,
	[EnviaBoleta] [bit] NULL,
	[EnviarFactura] [bit] NULL,
	[EnviaNC] [bit] NULL,
	[EnviaND] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[UsuarioID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Asistencia]  WITH CHECK ADD FOREIGN KEY([PersonalId])
REFERENCES [dbo].[Personal] ([PersonalId])
GO
ALTER TABLE [dbo].[CajaDetalle]  WITH CHECK ADD FOREIGN KEY([CajaId])
REFERENCES [dbo].[Caja] ([CajaId])
GO
ALTER TABLE [dbo].[Combinacion_Mesas]  WITH CHECK ADD FOREIGN KEY([id_mesa])
REFERENCES [dbo].[tbl_mesa] ([id_mesa])
GO
ALTER TABLE [dbo].[Combinacion_Mesas]  WITH CHECK ADD FOREIGN KEY([IdOrden])
REFERENCES [dbo].[Tbl_Orden_Pedido] ([IdOrden])
GO
ALTER TABLE [dbo].[Compras]  WITH CHECK ADD FOREIGN KEY([CompaniaId])
REFERENCES [dbo].[Compania] ([CompaniaId])
GO
ALTER TABLE [dbo].[Compras]  WITH CHECK ADD FOREIGN KEY([ProveedorId])
REFERENCES [dbo].[Proveedor] ([ProveedorId])
GO
ALTER TABLE [dbo].[DetaLiquidaVenta]  WITH CHECK ADD FOREIGN KEY([LiquidacionId])
REFERENCES [dbo].[LiquidacionVenta] ([LiquidacionId])
GO
ALTER TABLE [dbo].[DetaLiquidaVenta]  WITH CHECK ADD FOREIGN KEY([NotaId])
REFERENCES [dbo].[NotaPedido] ([NotaId])
GO
ALTER TABLE [dbo].[DetalleApertura]  WITH CHECK ADD FOREIGN KEY([IdApertura])
REFERENCES [dbo].[AperturaInsumos] ([IdApertura])
GO
ALTER TABLE [dbo].[DetalleBloque]  WITH CHECK ADD FOREIGN KEY([BloqueId])
REFERENCES [dbo].[BLOQUE] ([BloqueId])
GO
ALTER TABLE [dbo].[DetalleCompra]  WITH CHECK ADD FOREIGN KEY([CompraId])
REFERENCES [dbo].[Compras] ([CompraId])
GO
ALTER TABLE [dbo].[DetalleDocumento]  WITH CHECK ADD FOREIGN KEY([DocuId])
REFERENCES [dbo].[DocumentoVenta] ([DocuId])
GO
ALTER TABLE [dbo].[DetalleDocumento]  WITH CHECK ADD FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Producto] ([IdProducto])
GO
ALTER TABLE [dbo].[DetalleGuia]  WITH CHECK ADD FOREIGN KEY([GuiaId])
REFERENCES [dbo].[GuiaRemision] ([GuiaId])
GO
ALTER TABLE [dbo].[DetalleGuia]  WITH CHECK ADD FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Producto] ([IdProducto])
GO
ALTER TABLE [dbo].[DetalleLetra]  WITH CHECK ADD FOREIGN KEY([LetraId])
REFERENCES [dbo].[Letra] ([LetraId])
GO
ALTER TABLE [dbo].[DetalleLiquida]  WITH CHECK ADD FOREIGN KEY([LiquidacionId])
REFERENCES [dbo].[Liquidacion] ([LiquidacionId])
GO
ALTER TABLE [dbo].[DetallePedido]  WITH CHECK ADD FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Producto] ([IdProducto])
GO
ALTER TABLE [dbo].[DetallePedido]  WITH CHECK ADD FOREIGN KEY([NotaId])
REFERENCES [dbo].[NotaPedido] ([NotaId])
GO
ALTER TABLE [dbo].[DocumentoCanje]  WITH CHECK ADD FOREIGN KEY([CompraId])
REFERENCES [dbo].[Compras] ([CompraId])
GO
ALTER TABLE [dbo].[DocumentoCanje]  WITH CHECK ADD FOREIGN KEY([LetraId])
REFERENCES [dbo].[Letra] ([LetraId])
GO
ALTER TABLE [dbo].[DocumentoVenta]  WITH CHECK ADD FOREIGN KEY([ClienteId])
REFERENCES [dbo].[Cliente] ([ClienteId])
GO
ALTER TABLE [dbo].[DocumentoVenta]  WITH CHECK ADD FOREIGN KEY([CompaniaId])
REFERENCES [dbo].[Compania] ([CompaniaId])
GO
ALTER TABLE [dbo].[DocumentoVenta]  WITH CHECK ADD FOREIGN KEY([NotaId])
REFERENCES [dbo].[NotaPedido] ([NotaId])
GO
ALTER TABLE [dbo].[GuiaCanje]  WITH CHECK ADD FOREIGN KEY([CompraId])
REFERENCES [dbo].[Compras] ([CompraId])
GO
ALTER TABLE [dbo].[Letra]  WITH CHECK ADD FOREIGN KEY([ProveedorId])
REFERENCES [dbo].[Proveedor] ([ProveedorId])
GO
ALTER TABLE [dbo].[NotaPedido]  WITH CHECK ADD FOREIGN KEY([ClienteId])
REFERENCES [dbo].[Cliente] ([ClienteId])
GO
ALTER TABLE [dbo].[NotaPedido]  WITH CHECK ADD FOREIGN KEY([CompaniaId])
REFERENCES [dbo].[Compania] ([CompaniaId])
GO
ALTER TABLE [dbo].[Personal]  WITH CHECK ADD FOREIGN KEY([AreaId])
REFERENCES [dbo].[Area] ([AreaId])
GO
ALTER TABLE [dbo].[Personal]  WITH CHECK ADD FOREIGN KEY([CompaniaId])
REFERENCES [dbo].[Compania] ([CompaniaId])
GO
ALTER TABLE [dbo].[Producto]  WITH CHECK ADD FOREIGN KEY([IdSubLinea])
REFERENCES [dbo].[Sublinea] ([IdSubLinea])
GO
ALTER TABLE [dbo].[RentaMensual]  WITH CHECK ADD FOREIGN KEY([CompaniaId])
REFERENCES [dbo].[Compania] ([CompaniaId])
GO
ALTER TABLE [dbo].[Sublinea]  WITH CHECK ADD FOREIGN KEY([IdLinea])
REFERENCES [dbo].[Linea] ([IdLinea])
GO
ALTER TABLE [dbo].[Tbl_Detalle_Orden]  WITH CHECK ADD FOREIGN KEY([IdOrden])
REFERENCES [dbo].[Tbl_Orden_Pedido] ([IdOrden])
GO
ALTER TABLE [dbo].[Tbl_Detalle_Orden]  WITH CHECK ADD FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Producto] ([IdProducto])
GO
ALTER TABLE [dbo].[TemporalCompra]  WITH CHECK ADD FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Producto] ([IdProducto])
GO
ALTER TABLE [dbo].[TemporalGuia]  WITH CHECK ADD FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Producto] ([IdProducto])
GO
ALTER TABLE [dbo].[TemporalGuia]  WITH CHECK ADD FOREIGN KEY([UsuarioID])
REFERENCES [dbo].[Usuarios] ([UsuarioID])
GO
ALTER TABLE [dbo].[temporalLetra]  WITH CHECK ADD FOREIGN KEY([CompraId])
REFERENCES [dbo].[Compras] ([CompraId])
GO
ALTER TABLE [dbo].[temporalLetra]  WITH CHECK ADD FOREIGN KEY([CompraId])
REFERENCES [dbo].[Compras] ([CompraId])
GO
ALTER TABLE [dbo].[TemporalLiVenta]  WITH CHECK ADD FOREIGN KEY([NotaId])
REFERENCES [dbo].[NotaPedido] ([NotaId])
GO
ALTER TABLE [dbo].[TemporalVenta]  WITH CHECK ADD FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Producto] ([IdProducto])
GO
ALTER TABLE [dbo].[TemporalVenta]  WITH CHECK ADD FOREIGN KEY([UsuarioID])
REFERENCES [dbo].[Usuarios] ([UsuarioID])
GO
ALTER TABLE [dbo].[Usuarios]  WITH CHECK ADD FOREIGN KEY([PersonalId])
REFERENCES [dbo].[Personal] ([PersonalId])
GO
/****** Object:  StoredProcedure [dbo].[AcuentaPedido]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[AcuentaPedido]
@NotaId numeric(38)
as
begin
select
'NroCaja|Fecha|Movimiento|Efectivo|Monto|Vuelto¬100|140|110|120|120|120¬String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+convert(varchar,c.CajaId)+'|'+
Convert(char(10),c.DetalleFecha,103)+' '+Convert(char(8),c.DetalleFecha,114)+'|'+
c.DetalleMovimiento+'|'+CONVERT(VarChar(50),cast(c.DetalleEfectivo as money ), 1)+'|'+
CONVERT(VarChar(50),cast(c.DetalleMonto as money ), 1)+'|'+
CONVERT(VarChar(50),cast(c.DetalleVuelto as money ), 1)
from CajaDetalle c
where c.NotaId=@NotaId
order by DetalleId asc
FOR XML PATH('')),1,1,'')),'~')+'['+
'FechaPago|Liquidacion|Documento|SaldoDocu|Acuenta|SaldoActual¬110|125|120|120|120|120¬String|String|String|String|String|String¬'+
isnull((select stuff((select '¬'+ Convert(char(10),d.FechaPago,103)+'|'+'LQ '+l.LiquidacionNumero+'|'+
case when n.NotaDocu='PROFORMA V' then
substring(n.NotaDocu,1,1)+'V '+convert(varchar,n.NotaId)
else substring(n.NotaDocu,1,1)+'V '+n.NotaSerie+'-'+n.NotaNumero end+'|'+
CONVERT(VarChar(50),cast(d.SaldoDocu as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.AcuentaGeneral as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.SaldoActual as money ), 1)
from DetaLiquidaVenta d
inner join LiquidacionVenta l
on l.LiquidacionId=d.LiquidacionId
inner join NotaPedido n
on n.NotaId=d.NotaId
where d.NotaId=@NotaId
order by d.DetalleId asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[anularDocumento]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[anularDocumento]  
@ListaOrden varchar(Max)  
as  
begin  
Declare @pos int  
Declare @orden varchar(max)  
Declare @detalle varchar(max)  
Set @pos = CharIndex('[',@ListaOrden,0)  
Set @orden = SUBSTRING(@ListaOrden,1,@pos-1)  
Set @detalle = SUBSTRING(@ListaOrden,@pos+1,len(@ListaOrden)-@pos)  
declare @p1 int,@p2 int,  
        @p3 int,@p4 int
          
declare @DocuId numeric(38),  
@NotaId numeric(38),  
@DocuUsuario varchar(80),  
@DetalleId numeric(38),  
@Documento varchar(40)

  
Set @orden= LTRIM(RTrim(@orden))  
Set @p1 = CharIndex('|',@orden,0)  
Set @p2 = CharIndex('|',@orden,@p1+1)  
Set @p3 = CharIndex('|',@orden,@p2+1)
Set @p4 = Len(@orden)+1 
 
Set @DocuId=convert(numeric(38),SUBSTRING(@orden,1,@p1-1))  
Set @NotaId=convert(numeric(38),SUBSTRING(@orden,@p1+1,@p2-@p1-1))  
Set @DocuUsuario=SUBSTRING(@orden,@p2+1,@p3-@p2-1)  
set @Documento=SUBSTRING(@orden,@p3+1,@p4-@p3-1)

  
set @DetalleId=isnull((select top 1 d.DetalleId from CajaDetalle d  
where d.NotaId=@NotaId   
order by d.DetalleId desc),0)
  
Begin Transaction  
update DocumentoVenta  
set DocuEstado='ANULADO'  
where DocuId=@DocuId  

update NotaPedido set ModificadoPor=@DocuUsuario,FechaEdita=GETDATE(),NotaEstado='ANULADO',  
NotaSaldo=NotaPagar,NotaAcuenta=0   
where NotaId=@NotaId  

delete from CajaDetalle  
where DetalleId=@DetalleId  

Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')   
Open Tabla  
Declare @Columna varchar(max),  
  @IdProducto numeric(20),  
  @Cantidad decimal(18,2),  
  @Precio decimal(18,2),
  @ValorUm decimal(18,4)
    
Declare  @IniciaStock decimal(18,2),  
         @StockFinal decimal(18,2)  

Declare @d1 int,@d2 int,
        @d3 int,@d4 int
  
Fetch Next From Tabla INTO @Columna  
 While @@FETCH_STATUS = 0  
 Begin  

Set @d1 = CharIndex('|',@Columna,0)  
Set @d2 = CharIndex('|',@Columna,@d1+1)
Set @d3 = CharIndex('|',@Columna,@d2+1)   
Set @d4 = Len(@Columna)+1
  
Set @IdProducto=Convert(numeric(38),SUBSTRING(@Columna,1,@d1-1))  
Set @Cantidad=Convert(decimal(18,2),SUBSTRING(@Columna,@d1+1,@d2-(@d1+1)))  
Set @Precio=Convert(decimal(18,2),SUBSTRING(@Columna,@d2+1,@d3-(@d2+1)))
Set @ValorUm=Convert(decimal(18,4),SUBSTRING(@Columna,@d3+1,@d4-(@d3+1)))

 set @Cantidad=@Cantidad*@ValorUm
  
 set @IniciaStock=(select top 1 ProductoCantidad from Producto where IdProducto=@IdProducto)  
 set @StockFinal=@IniciaStock+@Cantidad  
 
 insert into Kardex values(@IdProducto,GETDATE(),'Anulacion por Venta',@Documento,@IniciaStock,  
 @Cantidad,0,@Precio,@StockFinal,'INGRESO',@DocuUsuario)  
 
 update producto   
 set  ProductoCantidad =ProductoCantidad + @Cantidad  
 where IDProducto=@IdProducto  

Fetch Next From Tabla INTO @Columna  
end  
 Close Tabla;  
 Deallocate Tabla;  
 Commit Transaction;  
 select 'true'  
end
GO
/****** Object:  StoredProcedure [dbo].[ap_insertarCanje]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ap_insertarCanje]
@LetraId  numeric(38),
@CompraId numeric(38),
@Documento varchar(60),
@Moneda varchar(60),
@Monto    varchar(80)
as
begin
insert into DocumentoCanje values(@LetraId,@CompraId,@Documento,@Moneda,@Monto)
end
GO
/****** Object:  StoredProcedure [dbo].[ap_Reimprimir]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ap_Reimprimir] 
@NotaId numeric(38),
@Usuario varchar(60)
as
begin
begin
update DetallePedido
set DetalleEstado='PENDIENTE'
where NotaId=@NotaId
end
begin
update NotaPedido
set NotaDocu='PROFORMA V',NotaEstado='PENDIENTE',
NotaSerie='',NotaNumero='',ModificadoPor=@Usuario
where NotaId=@NotaId
end
end
GO
/****** Object:  StoredProcedure [dbo].[ap_xEntregar]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ap_xEntregar]
as
begin
select 
'Codigo|RazonSocial|Direccion|Telefono¬80|355|80|80¬String|String|String|String¬'+
isnull((select STUFF((select '¬'+convert(varchar,c.ClienteId)+'|'+c.ClienteRazon+'|'+c.ClienteDespacho+'|'+c.ClienteTelefono
from DetallePedido d
inner join NotaPedido n
on n.NotaId=d.NotaId
inner join cliente c
on c.ClienteId=n.ClienteId
where d.cantidadSaldo>0 and (n.NotaEstado<>'ANULADO' and n.NotaEntrega='POR ENTREGAR')
group by c.ClienteId,c.ClienteRazon,c.ClienteDespacho,c.ClienteTelefono
order by c.ClienteRazon asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[aumentarStockCompra]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[aumentarStockCompra]
@IdProducto numeric(38),
@Cantidad decimal(18,2),
@Costo decimal(18,4),
@Estado varchar(40),
@Documento varchar(80),
@usuario varchar(80)
as
begin
declare @IniciaStock decimal(18,2),@stockFinal decimal(18,2)
set @IniciaStock=(select top 1 p.ProductoCantidad from Producto p where p.IdProducto=@IdProducto)
set @stockFinal=@IniciaStock+@Cantidad
if(@Estado='BONIFICACION')
begin
update Producto 
set ProductoCantidad=ProductoCantidad+@Cantidad
where IdProducto=@IdProducto 
end
else
begin
update Producto 
set ProductoCantidad=ProductoCantidad+@Cantidad,ProductoCosto=@Costo
where IdProducto=@IdProducto 
end
insert into Kardex values(@IdProducto,GETDATE(),'Ingreso por Compra',@Documento,@IniciaStock,
@Cantidad,0,@Costo,@StockFinal,'INGRESO',@Usuario)
end
GO
/****** Object:  StoredProcedure [dbo].[aumentaSaldo]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[aumentaSaldo]
@Cantidad decimal(18,2),
@IdDetalle numeric(38)
as
update DetallePedido
set CantidadSaldo=CantidadSaldo+@Cantidad
where DetalleId=@IdDetalle
GO
/****** Object:  StoredProcedure [dbo].[buscarProducto]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[buscarProducto] 
@Descripcion varchar(80)
as
begin
select top 150 p.IdProducto as ID,s.NombreSublinea as Categoria,p.ProductoCodigo as Codigo,
p.ProductoNombre as Descripcion,
CONVERT(VarChar(50), cast(p.ProductoCantidad as money ), 1) as STOCK,p.ProductoUM as UM,
CONVERT(VarChar(50), cast(p.ProductoVenta as money ), 1)as PrecioVenta,
CONVERT(VarChar(50), cast(p.ProductoVentaB as money ), 1)as PrecioVentaB,
p.ProductoCosto as PrecioCosto,'1' as ValorUM,p.ValorCritico
FROM Producto p
INNER JOIN Sublinea s
ON p.IdSubLinea =s.IdSubLinea 
where (p.ProductoNombre like '%'+@Descripcion+'%') and p.ProductoEstado='BUENO'
union all(
select top 150 p.IdProducto as ID,s.NombreSublinea as Categoria,p.ProductoCodigo as Codigo,
p.ProductoNombre as Descripcion,
CONVERT(VarChar(50), cast((p.ProductoCantidad/u.ValorUM)as money ), 1) as STOCK,u.UMDescripcion as UM,
CONVERT(VarChar(50), cast(u.PrecioVenta as money ), 1)as PrecioVenta,
CONVERT(VarChar(50), cast(u.PrecioVentaB as money ), 1)as PrecioVentaB,
u.PrecioCosto,u.ValorUM,p.ValorCritico
from UnidadMedida u
inner join Producto p
on p.IdProducto=u.IdProducto
INNER JOIN Sublinea s
ON p.IdSubLinea =s.IdSubLinea 
where (p.ProductoNombre like'%'+@Descripcion+'%') and p.ProductoEstado='BUENO')
order by 7 asc
end
GO
/****** Object:  StoredProcedure [dbo].[buscarProductoB]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[buscarProductoB] 
@Descripcion varchar(80)
as
begin
select top 150 p.IdProducto as ID,s.NombreSublinea as Categoria,p.ProductoCodigo as Codigo,
p.ProductoNombre as Descripcion,
CONVERT(VarChar(50), cast(p.ProductoCantidad as money ), 1) as STOCK,p.ProductoUM as UM,
CONVERT(VarChar(50), cast(p.ProductoVenta as money ), 1)as PrecioVenta,
CONVERT(VarChar(50), cast(p.ProductoVentaB as money ), 1)as PrecioVentaB,
p.ProductoCosto as PrecioCosto,'1' as ValorUM,p.ValorCritico
FROM Producto p
INNER JOIN Sublinea s
ON p.IdSubLinea =s.IdSubLinea
where (p.ProductoNombre like'%'+@Descripcion+'%') and p.ProductoEstado='BUENO'
order by 7 asc
end
GO
/****** Object:  StoredProcedure [dbo].[buscarSubLinea]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[buscarSubLinea] 
@IdSubLinea numeric(20)
as
begin
select p.IdProducto as ID,s.NombreSublinea as Categoria,p.ProductoCodigo as Codigo,
p.ProductoNombre as Descripcion,
CONVERT(VarChar(50), cast(p.ProductoCantidad as money ), 1) as STOCK,p.ProductoUM as UM,
CONVERT(VarChar(50), cast(p.ProductoVenta as money ), 1)as PrecioVenta,
CONVERT(VarChar(50), cast(p.ProductoVentaB as money ), 1)as PrecioVentaB,
p.ProductoCosto as PrecioCosto,'1' as ValorUM,p.ValorCritico
FROM Producto p
INNER JOIN Sublinea s
ON p.IdSubLinea =s.IdSubLinea 
union all(
select p.IdProducto as ID,s.NombreSublinea as Categoria,p.ProductoCodigo as Codigo,
p.ProductoNombre as Descripcion,
CONVERT(VarChar(50), cast((p.ProductoCantidad/u.ValorUM)as money ), 1) as STOCK,u.UMDescripcion as UM,
CONVERT(VarChar(50), cast(u.PrecioVenta as money ), 1)as PrecioVenta,
CONVERT(VarChar(50), cast(u.PrecioVentaB as money ), 1)as PrecioVentaB,
u.PrecioCosto,u.ValorUM,p.ValorCritico
from UnidadMedida u
inner join Producto p
on p.IdProducto=u.IdProducto
INNER JOIN Sublinea s
ON p.IdSubLinea =s.IdSubLinea 
where p.IdSubLinea=@IdSubLinea)
order by 7 asc
end
GO
/****** Object:  StoredProcedure [dbo].[buscaValorCritico]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[buscaValorCritico] 
@Descripcion varchar(80)
as
begin
select top 200 p.IdProducto,p.ProductoCodigo as Codigo,p.ProductoNombre as Descripcion,
CONVERT(VarChar(50), cast(p.ProductoCantidad as money ), 1) as Stock,
p.ProductoUM as UM,p.ProductoCosto as Costo
from Producto p
where p.ProductoNombre like '%'+@Descripcion+'%' and (p.ProductoCantidad < = p.ValorCritico)
order by 3 asc
end
GO
/****** Object:  StoredProcedure [dbo].[cajaPrincipal]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[cajaPrincipal]
as
begin
select
'ID|Concepto|CajaId|Fecha|Descripcion|Monto|Usuario|Imagen¬90|100|80|136|355|120|100|90¬String|String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+ convert(varchar,c.IdCaja)+'|'+c.CajaConcepto+'|'+convert(varchar,c.CajaId)+'|'+
Convert(char(10),c.CajaFecha,103)+' '+Convert(char(8),c.CajaFecha,114) 
+'|'+c.CajaDescripcion+'|'+CONVERT(VarChar(50),cast(c.CajaMonto as money), 1)+'|'+
c.CajaUsuario+'|'+c.RutaImagen 
from CajaPincipal c 
where c.CajaConcepto='INGRESO' and c.IdGeneral=0
order by c.IdCaja desc
for xml path('')),1,1,'')),'~')+'['+
'ID|Concepto|CajaId|Fecha|Descripcion|Monto|Usuario|Imagen¬90|100|80|135|435|125|100|90¬String|String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+ convert(varchar,c.IdCaja)+'|'+c.CajaConcepto+'|'+convert(varchar,c.CajaId)+'|'+
Convert(char(10),c.CajaFecha,103)+' '+Convert(char(8),c.CajaFecha,114) 
+'|'+c.CajaDescripcion+'|'+CONVERT(VarChar(50),cast(c.CajaMonto as money), 1)+'|'+
c.CajaUsuario+'|'+c.RutaImagen 
from CajaPincipal c 
where c.CajaConcepto='SALIDA' and c.IdGeneral=0
order by c.IdCaja desc
for xml path('')),1,1,'')),'~')+'['+
'Codigo|FechaCierre|Usuario|Ingresos|Salidas|Total¬100|200|250|130|130|130¬String|String|String|String|String|String¬'+
isnull((select STUFF ((select '¬'+ CONVERT(varchar,c.IdGeneral)+'|'+
(IsNull(convert(varchar,c.FechaCierre,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,c.FechaCierre,114),1,8),''))+'|'+c.Usuario+'|'+
CONVERT(varchar(50),cast(c.Ingresos as money),1)+'|'+CONVERT(varchar(50),cast(c.Salidas as money),1)+'|'+
CONVERT(varchar(50),cast(c.Total as money),1)
from CajaGeneral c
order by c.IdGeneral desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[canjearGuia]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[canjearGuia] 
@ProveedorId numeric(38)
as
begin
select
'CompraId|FechaEmision|Documento|Moneda|Saldo|Monto|Estado¬100|110|150|90|120|120|150¬String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+ convert(varchar,c.CompraId)+'|'+(Convert(char(10),c.CompraEmision,103))+'|'+
SUBSTRING(t.TipoDescripcion,1,1)+'C '+ c.CompraSerie+'-'+c.CompraNumero+'|'+c.CompraMoneda+'|'+
(convert(varchar(50), CAST(c.CompraSaldo as money), -1))+'|'+
(convert(varchar(50), CAST(c.CompraTotal as money), -1))+'|'+
c.CompraEstado
from Compras c
inner join TipoComprobante t
on t.TipoCodigo=c.TipoCodigo
where c.ProveedorId=@ProveedorId and c.TipoCodigo='09'
order by c.CompraEmision desc
for xml path('')),1,1,'')),'~')	
end
GO
/****** Object:  StoredProcedure [dbo].[CanjeFacturaFecha]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CanjeFacturaFecha]
@fechainicio date,
@fechafin date
as
begin
SELECT dbo.GuiaCanje.*, dbo.Compras.CompraMoneda as Moneda,(convert(varchar(50), CAST(dbo.Compras.CompraValorVenta as money), -1))as Total,
(SUBSTRING(dbo.Compras.CompraMoneda,1,1)+'/.  '+(convert(varchar(50), CAST(dbo.Compras.CompraTotal as money), -1)))as Monto,dbo.Proveedor.ProveedorRazon as Proveedor
FROM dbo.GuiaCanje INNER JOIN dbo.Compras ON dbo.GuiaCanje.CompraId = dbo.Compras.CompraId inner join dbo.Proveedor on dbo.Proveedor.ProveedorId=dbo.Compras.ProveedorId 
where (Convert(char(10),dbo.GuiaCanje.CanjeFecha,103) BETWEEN @fechainicio AND @fechafin) 
order by dbo.GuiaCanje.CanjeId desc
end
GO
/****** Object:  StoredProcedure [dbo].[CantidadVendidas]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CantidadVendidas] 
@MES INT,
@ANNO INT
as
begin
select 'Id|SubLinea¬0|300¬'+
(select STUFF((select '¬'+ convert(varchar,s.IdSubLinea)+'|'+s.NombreSublinea
from Sublinea s
for XMl path('')),1,1,''))+'_'+
'Descripcion|Cantidad|UM|Venta|Ganancia¬520|125|100|125|125¬'+
(select STUFF((select '¬'+ p.ProductoNombre+'|'+
convert(varchar(50),cast(sum(d.DetalleCantidad)as money),1)+'|'+p.ProductoUM+'|'+
convert(varchar(50),cast(SUM(d.DetalleImporte)as money),1)+'|'+
convert(varchar(50),cast(sum((d.DetallePrecio-d.DetalleCosto)* d.DetalleCantidad)as money),1)+'|'+convert(varchar,p.IdSubLinea)
from NotaPedido n
inner join DetallePedido d
on d.NotaId=n.NotaId
inner join Producto p
on p.IdProducto=d.IdProducto
where n.NotaEstado='CANCELADO' and 
(MONTH(n.NotaFecha)=@MES and year(n.NotaFecha)=@ANNO)
group by p.IdSubLinea,p.IdProducto,p.ProductoNombre,p.ProductoUM
order by p.IdSubLinea asc,sum(d.DetalleCantidad) desc
for XMl path('')),1,1,''))
end
GO
/****** Object:  StoredProcedure [dbo].[cargaPrincipal]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[cargaPrincipal]
as
begin
select
isnull((select STUFF((select '¬'+ convert(varchar,c.CompaniaId)+'|'+
c.CompaniaRazonSocial
from Compania c 
order by c.CompaniaId asc 
FOR XML PATH('')),1,1,'')),'~')+'['+
isnull((select STUFF((select '¬'+ convert(varchar,s.IdSubLinea)+'|'+
s.NombreSublinea 
from Sublinea s 
where s.NombreSublinea<>''
order by s.NombreSublinea asc
FOR XML PATH('')),1,1,'')),'~')+'['+
isnull((select STUFF((select '¬'+ t.TipoCodigo+'|'+
t.TipoDescripcion
from TipoComprobante t
order by t.TipoCodigo asc
FOR XML PATH('')),1,1,'')),'~')+'['+
isnull((select STUFF((select '¬'+ convert(varchar,a.AreaId)+'|'+
a.AreaNombre 
from Area a
order by a.AreaNombre asc
FOR XML PATH('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[cargarDatosOrdenPedido]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[cargarDatosOrdenPedido]
@IdOrden varchar(38)
AS
BEGIN
	select
	isnull((select STUFF((select '¬'+ convert(varchar,o.IdOrden)+'|'+
	convert(varchar,o.ClienteId)+'|'+
	c.ClienteRazon+'|'+
    IsNull(convert(varchar,o.FechaOrden,103),'')+' '+IsNull(SUBSTRING(convert(varchar,o.FechaOrden,114),1,8),'')+'|'+
	IsNull(SUBSTRING(convert(varchar,o.HoraFin,114),1,8),'')+'|'+
	o.OrdenSerie+'|'+o.OrdenNumero+'|'+o.NroMesas+'|'+o.Observaciones+'|'+
	o.Usuario+'|'+o.Estado
	from Tbl_Orden_Pedido o 
	inner join Cliente c 
	on o.ClienteId= c.ClienteId
	where o.IdOrden=@IdOrden --and o.Estado<> 'ANULADO'
	order by o.IdOrden asc 
	FOR XML PATH('')),1,1,'')),'~')+'['+
	isnull((select STUFF((select '¬'+ 
	convert(varchar,d.DetalleId)+'|'+ 
	convert(varchar,d.IdProducto)+'|'+p.ProductoNombre+'|'+ 
	convert(varchar,d.PrecioUni)+'|'+
	convert(varchar,d.Cantidad) + '|'+ 
	convert(varchar,d.Importe)+'|'+
	convert(varchar,p.ProductoCosto)+'|'+
	convert(varchar,p.ProductoVentaB)+'|'+
	convert(varchar,d.IdOrden)+'|'+d.estado+'|'+
	convert(varchar,s.EnviarIMP)
	from Tbl_Detalle_Orden d	
	inner join Producto p 
	on d.IdProducto=p.IdProducto
	inner join Sublinea s
	on p.IdSubLinea=s.IdSubLinea
	where d.IdOrden=@IdOrden
	order by d.DetalleId asc
	FOR XML PATH('')),1,1,'')),'~')
END
GO
/****** Object:  StoredProcedure [dbo].[ClientesAtendidos]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[ClientesAtendidos]
@ANNO INT,
@VENDEDOR VARCHAR(40)
as
begin
select MONTH(N.NotaFecha)as Numero,
(DATENAME(month,n.NotaFecha)) as Mes,n.NotaUsuario as Usuario,
COUNT(ClienteId) as Clientes
from NotaPedido n
where YEAR(n.NotaFecha)=@ANNO and (n.NotaUsuario=@VENDEDOR and n.NotaEstado='CANCELADO')
group by MONTH(N.NotaFecha),(DATENAME(month,n.NotaFecha)),n.NotaUsuario
order by 1 asc
end
GO
/****** Object:  StoredProcedure [dbo].[comboGuias]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[comboGuias]
@ClienteId numeric(20)
as
begin
Select
(select STUFF((select '¬' +convert(varchar,g.GuiaId)+'|'+g.GuiaNumero
from GuiaRemision g
where (g.ClienteId=@ClienteId and g.GuiaConcepto='SALIDA') and g.guiaEstado=''
order by 1 asc
for xml path('')),1,1,''))+'['+
'IdPro|Cantidad|UM|Descripcion|PrecioUni|Importe|Costo|ValorUM¬0|100|100|410|125|125|0|0¬'+
(select STUFF((select '¬' + convert(varchar,d.IdProducto)+'|'+
CONVERT(VarChar(50),cast(d.DetalleCantidad as money), 1)+'|'+d.UniMedida+'|'+
p.ProductoNombre+'|'+
CONVERT(VarChar(50), cast(d.DetallePrecio as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DetalleImporte as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DetalleCosto as money ), 1)+'|'+ 
CONVERT(varchar,d.ValorUM)+'|'+
convert(varchar,d.GuiaId)
from GuiaRemision g
inner join DetalleGuia d
on d.GuiaId=g.GuiaId
inner join Producto p
on p.IdProducto=d.IdProducto
where g.clienteId=@ClienteId and g.guiaEstado=''
order by d.DetalleId asc
for xml path('')),1,1,''))
end
GO
/****** Object:  StoredProcedure [dbo].[CorrelativoCompra]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CorrelativoCompra]
@CompaniaId int,
@anno int,
@mes int
as
begin
select top 1 c.CompraCorrelativo as Correlativo from Compras c
where CompaniaId=@CompaniaId and (year(CompraComputo)=@anno and MONTH(CompraComputo)=@mes)
order by c.CompraCorrelativo desc
end
GO
/****** Object:  StoredProcedure [dbo].[CorrelativoLiquida]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CorrelativoLiquida]
as
begin
declare @cod varchar(12)
select @cod=dbo.geneneraIdLiquida('001-')
SELECT TOP 1 @cod  AS ID FROM Liquidacion
end
GO
/****** Object:  StoredProcedure [dbo].[CorrelativoLiVenta]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CorrelativoLiVenta]
as
begin
declare @cod varchar(12)
select @cod=dbo.geneneraIdLiVenta('001-')
SELECT TOP 1 @cod  AS ID FROM LiquidacionVenta
end
GO
/****** Object:  StoredProcedure [dbo].[correlativoNroFactura]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[correlativoNroFactura]@dato varchar(20),@CompaniaId int,@DocuDocumento varchar(40)
as
begin
declare @cod varchar(13)
select @cod=dbo.genenerarNroFactura(@dato,@CompaniaId,@DocuDocumento)
SELECT TOP 1 @cod  AS ID FROM DocumentoVenta
end
GO
/****** Object:  StoredProcedure [dbo].[correlativoNroGuia]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[correlativoNroGuia] @dato varchar(20)
as
begin
declare @cod varchar(11)
select @cod=dbo.genenerarNroGuia(@dato)
SELECT TOP 1 @cod  AS ID FROM GuiaRemision
end
GO
/****** Object:  StoredProcedure [dbo].[correlativoNroTicket]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[correlativoNroTicket] 
@dato varchar(20)
as
begin
declare @cod varchar(13)
select @cod=dbo.genenerarNroTicket(@dato)
SELECT TOP 1 @cod  AS ID 
FROM Tbl_Orden_Pedido
end
GO
/****** Object:  StoredProcedure [dbo].[CuentaCorrienteCliente]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[CuentaCorrienteCliente]
as
begin
select
'ClienteId|Cliente|SaldoSol¬100|525|140¬String|String|String¬'+
isnull((select stuff((select '¬'+ convert(varchar,c.ClienteId)+'|'+c.ClienteRazon+'|'+
CONVERT(VarChar(50), cast(sum(n.NotaSaldo)as money ), 1)
from NotaPedido n
inner join Cliente c
on c.ClienteId=n.ClienteId
where (n.NotaSaldo>0 and n.NotaEstado<>'CANCELADO') and n.NotaCondicion='CREDITO'
group by c.ClienteId,c.ClienteRazon
order by c.ClienteRazon asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[CuentaCorrienteProCom]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CuentaCorrienteProCom] 
@CompaniaId varchar(40)
as
begin
select isnull(SC.ProveedorId,ISNULL(DC.ProveedorId,ISNULL(LS.ProveedorId,LD.ProveedorId))) as ProveedorId
,isnull(SC.RazonSocial,ISNULL(DC.RazonSocial,ISNULL(LS.RazonSocial,LD.RazonSocial))) as ProveedorRazon,
convert(varchar(50),cast((isnull(Sum(DC.SaldoDol),0)+ isnull(sum(LD.SaldoDolLe),0))as money),1)as SaldoDol,
convert(varchar(50),cast((isnull(Sum(SC.SaldoSol),0)+ isnull(sum(LS.SaldoSolLe),0))as money),1)as SaldoSol
from
(
    select p.ProveedorId,p.ProveedorRazon as RazonSocial,Sum(c.CompraSaldo)as SaldoSol
	from Proveedor p
	inner join Compras c
	on c.ProveedorId=p.ProveedorId
	where c.CompaniaId=@CompaniaId and (c.CompraMoneda='SOLES' and c.CompraEstado='PENDIENTE DE PAGO')
	group by p.ProveedorId,p.ProveedorRazon
) SC
full join(
  select p.ProveedorId,p.ProveedorRazon as RazonSocial,Sum(c.CompraSaldo)as SaldoDol
	from Proveedor p
	inner join Compras c
	on c.ProveedorId=p.ProveedorId
	where c.CompaniaId=@CompaniaId and (c.CompraMoneda='DOLARES' and c.CompraEstado='PENDIENTE DE PAGO')
	group by p.ProveedorId,p.ProveedorRazon
)DC ON SC.ProveedorId=DC.ProveedorId
full join(
select p.ProveedorId,p.ProveedorRazon as RazonSocial,
		Sum(d.DetalleSaldo)as SaldoSolLe
	from Proveedor p
	inner join Letra l
	on l.ProveedorId=p.ProveedorId
	inner join DetalleLetra d
	on d.LetraId=l.LetraId
	where l.CompaniaId=@CompaniaId and(l.LetraMoneda='SOLES' and d.DetalleEstado='PENDIENTE')
group by p.ProveedorId,p.ProveedorRazon
)LS ON LS.ProveedorId=SC.ProveedorId
full join(
select p.ProveedorId,p.ProveedorRazon as RazonSocial,
		Sum(d.DetalleSaldo)as SaldoDolLe
	from Proveedor p
	inner join Letra l
	on l.ProveedorId=p.ProveedorId
	inner join DetalleLetra d
	on d.LetraId=l.LetraId
	where l.CompaniaId=@CompaniaId and (l.LetraMoneda='DOLARES' and d.DetalleEstado='PENDIENTE')
group by p.ProveedorId,p.ProveedorRazon
)LD ON LS.ProveedorId=LD.ProveedorId
GROUP BY SC.ProveedorId,DC.ProveedorId,LS.ProveedorId,LD.ProveedorId,
		 SC.RazonSocial,DC.RazonSocial,LS.RazonSocial,LD.RazonSocial
order by 2 asc
end
GO
/****** Object:  StoredProcedure [dbo].[CuentaCorrienteProveedor]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CuentaCorrienteProveedor]
as
begin
select isnull(SC.ProveedorId,ISNULL(DC.ProveedorId,ISNULL(LS.ProveedorId,LD.ProveedorId))) as ProveedorId
,isnull(SC.RazonSocial,ISNULL(DC.RazonSocial,ISNULL(LS.RazonSocial,LD.RazonSocial))) as ProveedorRazon,
convert(varchar(50),cast((isnull(Sum(DC.SaldoDol),0)+ isnull(sum(LD.SaldoDolLe),0))as money),1)as SaldoDol,
convert(varchar(50),cast((isnull(Sum(SC.SaldoSol),0)+ isnull(sum(LS.SaldoSolLe),0))as money),1)as SaldoSol
from
(
    select p.ProveedorId,p.ProveedorRazon as RazonSocial,Sum(c.CompraSaldo)as SaldoSol
	from Proveedor p
	inner join Compras c
	on c.ProveedorId=p.ProveedorId
	where c.CompraMoneda='SOLES' and c.CompraEstado='PENDIENTE DE PAGO'
	group by p.ProveedorId,p.ProveedorRazon
) SC
full join(
  select p.ProveedorId,p.ProveedorRazon as RazonSocial,Sum(c.CompraSaldo)as SaldoDol
	from Proveedor p
	inner join Compras c
	on c.ProveedorId=p.ProveedorId
	where c.CompraMoneda='DOLARES' and c.CompraEstado='PENDIENTE DE PAGO'
	group by p.ProveedorId,p.ProveedorRazon
)DC ON SC.ProveedorId=DC.ProveedorId
full join(
select p.ProveedorId,p.ProveedorRazon as RazonSocial,
		Sum(d.DetalleSaldo)as SaldoSolLe
	from Proveedor p
	inner join Letra l
	on l.ProveedorId=p.ProveedorId
	inner join DetalleLetra d
	on d.LetraId=l.LetraId
	where l.LetraMoneda='SOLES' and d.DetalleEstado='PENDIENTE'
group by p.ProveedorId,p.ProveedorRazon
)LS ON LS.ProveedorId=SC.ProveedorId
full join(
select p.ProveedorId,p.ProveedorRazon as RazonSocial,
		Sum(d.DetalleSaldo)as SaldoDolLe
	from Proveedor p
	inner join Letra l
	on l.ProveedorId=p.ProveedorId
	inner join DetalleLetra d
	on d.LetraId=l.LetraId
	where l.LetraMoneda='DOLARES' and d.DetalleEstado='PENDIENTE'
group by p.ProveedorId,p.ProveedorRazon
)LD ON LS.ProveedorId=LD.ProveedorId
GROUP BY SC.ProveedorId,DC.ProveedorId,LS.ProveedorId,LD.ProveedorId,
		 SC.RazonSocial,DC.RazonSocial,LS.RazonSocial,LD.RazonSocial
order by 2 asc
end
GO
/****** Object:  StoredProcedure [dbo].[CuentasCorreienteCompania]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CuentasCorreienteCompania]
as
begin
select 
isnull(SC.CompaniaId,ISNULL(DC.CompaniaId,ISNULL(LS.CompaniaId,LD.CompaniaId))) as CompaniaId
,isnull(SC.RazonSocial,ISNULL(DC.RazonSocial,ISNULL(LS.RazonSocial,LD.RazonSocial))) as RazonSocial,
convert(varchar(50),cast((isnull(Sum(DC.SaldoDol),0)+ isnull(sum(LD.SaldoDolLe),0))as money),1)as SaldoDol,
convert(varchar(50),cast((isnull(Sum(SC.SaldoSol),0)+ isnull(sum(LS.SaldoSolLe),0))as money),1)as SaldoSol
from
(
select co.CompaniaId,co.CompaniaRazonSocial as RazonSocial,
sum(c.CompraSaldo)SaldoSol
from Compania co
inner join Compras c
on c.CompaniaId=co.CompaniaId
where c.CompraMoneda='SOLES' AND c.CompraEstado='PENDIENTE DE PAGO'
group by co.CompaniaId,co.CompaniaRazonSocial
) SC
FULL JOIN 
(
select co.CompaniaId,co.CompaniaRazonSocial as RazonSocial,
sum(c.CompraSaldo)as SaldoDol
from Compania co
inner join Compras c
on c.CompaniaId=co.CompaniaId
where c.CompraMoneda='DOLARES' AND c.CompraEstado='PENDIENTE DE PAGO'
group by co.CompaniaId,co.CompaniaRazonSocial
)DC ON DC.CompaniaId=SC.CompaniaId
full join
(
select l.CompaniaId,co.CompaniaRazonSocial as RazonSocial,SUM(d.DetalleSaldo) as SaldoSolLe
from DetalleLetra d
inner join Letra l
on l.LetraId=d.LetraId
inner join Compania co
on co.CompaniaId=l.CompaniaId
where d.DetalleEstado='PENDIENTE' and l.LetraMoneda='SOLES'
group by l.CompaniaId,co.CompaniaRazonSocial
)LS on LS.CompaniaId=SC.CompaniaId
full join(
select l.CompaniaId,co.CompaniaRazonSocial as RazonSocial,SUM(d.DetalleSaldo) as SaldoDolLe
from DetalleLetra d
inner join Letra l
on l.LetraId=d.LetraId
inner join Compania co
on co.CompaniaId=l.CompaniaId
where d.DetalleEstado='PENDIENTE' and l.LetraMoneda='DOLARES'
group by l.CompaniaId,co.CompaniaRazonSocial
)LD on LD.CompaniaId=LS.CompaniaId
GROUP BY SC.CompaniaId,DC.CompaniaId,LS.CompaniaId,LD.CompaniaId,
		 SC.RazonSocial,DC.RazonSocial,LS.RazonSocial,LD.RazonSocial
order by 2 asc
end
GO
/****** Object:  StoredProcedure [dbo].[DeudaCliente]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[DeudaCliente] @Cliente numeric(20)
as
begin
select
'ClienteId|FechaEmision|Documento|Vencimiento|Moneda|SaldoDocu|MontoDocu¬100|105|140|105|90|120|120¬String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+convert(varchar,n.ClienteId)+'|'+(Convert(char(10),n.NotaFecha,103))+'|'+
substring(n.NotaDocu,1,2)+' '+cast(n.NotaId as varchar(80))+'|'+
(Convert(char(10),n.NotaFechaPago,103))+'|'+'SOLES'+'|'+convert(varchar(50),cast(n.NotaSaldo as money),1)+'|'+
convert(varchar(50),cast(n.NotaPagar as money),1) 
from NotaPedido n
where n.notadocu<>'PROFORMA' and (n.ClienteId=@Cliente and ((n.NotaSaldo>0 and n.NotaEstado<>'CANCELADO') and n.NotaCondicion='CREDITO'))
order by n.NotaId desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[DeudasProveedor]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[DeudasProveedor] @ProveedorId numeric(38)
as
begin
select c.ProveedorId,c.CompraId,
(Convert(char(10),c.CompraEmision,103)) as CompraEmision,
substring(t.TipoDescripcion,1,1)+'C '+c.CompraSerie+'-'+c.CompraNumero as Documento,
(Convert(char(10),c.CompraFechaPago,103)) as Vencimiento,
c.CompraMoneda as Moneda,
c.CompraTipoCambio as TipoCambio,
convert(varchar(50),cast(c.CompraSaldo as money),1) as SaldoDoc,
convert(varchar(50),cast(c.CompraTotal as money),1) as MontoDoc
from Compras c
inner join TipoComprobante t
on t.TipoCodigo=c.TipoCodigo
where c.ProveedorId=@ProveedorId and c.CompraEstado='PENDIENTE DE PAGO'
union all
select l.ProveedorId,d.LetraId,(Convert(char(10),l.LetraFechaGiro,103))as LetraFechaGiro,
'LT '+d.LetraCanje as Documento,(Convert(char(10),d.LetraVencimiento,103))as LetraVencimiento,
l.LetraMoneda,'3.276' as TipoCambio,
convert(varchar(50),cast(d.DetalleSaldo as money),1) as DetalleSaldo,
convert(varchar(50),cast(d.DetalleMonto as money),1) as DetalleMonto
from DetalleLetra d
inner join Letra l
on l.LetraId=d.LetraId
where l.ProveedorId=@ProveedorId and d.DetalleEstado='PENDIENTE'
end
GO
/****** Object:  StoredProcedure [dbo].[DeudasProveedorA]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[DeudasProveedorA]
as
begin
select c.CompraId,(Convert(char(10),c.CompraEmision,103)) as CompraEmision,substring(t.TipoDescripcion,1,1)+'C '+c.CompraSerie+'-'+c.CompraNumero as Documento,
(Convert(char(10),c.CompraFechaPago,103)) as Vencimiento,c.CompraMoneda as Moneda,c.CompraTipoCambio as TipoCambio,
CONVERT(VarChar(50),cast(c.CompraSaldo as money ), 1) as SaldoDoc,CONVERT(VarChar(50),cast(c.CompraTotal as money ), 1) as MontoDoc
from Compras c
inner join TipoComprobante t
on t.TipoCodigo=c.TipoCodigo
where c.CompraEstado='PENDIENTE DE PAGO'
order by c.CompraFechaPago asc
end
GO
/****** Object:  StoredProcedure [dbo].[DeudasProveedorC]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[DeudasProveedorC] 
@CompaniaId varchar(40),
@ProveedorId numeric(38)
as
begin
select c.ProveedorId,c.CompraId,
(Convert(char(10),c.CompraEmision,103)) as CompraEmision,
substring(t.TipoDescripcion,1,1)+'C '+c.CompraSerie+'-'+c.CompraNumero as Documento,
(Convert(char(10),c.CompraFechaPago,103)) as Vencimiento,
c.CompraMoneda as Moneda,
c.CompraTipoCambio as TipoCambio,
convert(varchar(50),cast(c.CompraSaldo as money),1) as SaldoDoc,
convert(varchar(50),cast(c.CompraTotal as money),1) as MontoDoc
from Compras c
inner join TipoComprobante t
on t.TipoCodigo=c.TipoCodigo
where (c.CompaniaId=@CompaniaId and c.ProveedorId=@ProveedorId) and c.CompraEstado='PENDIENTE DE PAGO'
union all
select l.ProveedorId,d.LetraId,(Convert(char(10),l.LetraFechaGiro,103))as LetraFechaGiro,
'LT '+d.LetraCanje as Documento,(Convert(char(10),d.LetraVencimiento,103))as LetraVencimiento,
l.LetraMoneda,'3.276' as TipoCambio,
convert(varchar(50),cast(d.DetalleSaldo as money),1) as DetalleSaldo,
convert(varchar(50),cast(d.DetalleMonto as money),1) as DetalleMonto
from DetalleLetra d
inner join Letra l
on l.LetraId=d.LetraId
where (l.CompaniaId=@CompaniaId and l.ProveedorId=@ProveedorId) and d.DetalleEstado='PENDIENTE'
end
GO
/****** Object:  StoredProcedure [dbo].[editaDescontinuado]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editaDescontinuado]
@Data varchar(max)
as
Set @Data =LTRIM(RTrim(@Data))
	Declare @pos1 int
	declare @IdProducto numeric(20)
Set @pos1 = Len(@Data)+1
Set @IdProducto=convert(numeric(20),SUBSTRING(@Data,1,@pos1-1))
begin
	update Producto
	set ProductoEstado='BUENO'
	where IdProducto=@IdProducto
select
isnull((select STUFF((select '¬'+convert(varchar,p.IdProducto)+'|'+p.ProductoCodigo+'|'+
p.ProductoNombre+'|'+convert(varchar(50),cast(p.ProductoCantidad as money),1)+'|'+ 
p.ProductoUM+'|'+convert(varchar(50),cast(p.ProductoVenta as money),1)+'|'+
convert(varchar(50),cast(p.ProductoVentaB as money),1)+'|'+convert(varchar,p.ProductoCosto)+'|'+
p.ProductoEstado+'|'+p.ProductoUsuario+'|'+p.ProductoImagen
FROM Producto p with(nolock)
where p.ProductoEstado='DESCONTINUADO'
order by p.ProductoNombre asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[editaDetaCompra]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editaDetaCompra]
@Data varchar(max)
as
begin
Declare @pos1 int
Declare @pos2 int
Declare @pos3 int
Declare @pos4 int
Declare @pos5 int
Declare @pos6 int
declare @Id numeric(38),
@cantidad decimal(18,2),
@precioCosto decimal(18,4),
@Descuento decimal(18,4),
@importe decimal(18,2),
@CompraId numeric(38)
Set @Data = LTRIM(RTrim(@Data))
Set @pos1 = CharIndex('|',@Data,0)
Set @Id =convert(numeric(38),SUBSTRING(@Data,1,@pos1-1))
Set @pos2 = CharIndex('|',@Data,@pos1+1)
Set @cantidad=convert(decimal(18,2),SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))
Set @pos3 = CharIndex('|',@Data,@pos2+1)
Set @precioCosto=convert(decimal(18,4),SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1))
Set @pos4 = CharIndex('|',@Data,@pos3+1)
Set @Descuento=convert(decimal(18,4),SUBSTRING(@Data,@pos3+1,@pos4-@pos3-1))
Set @pos5= CharIndex('|',@Data,@pos4+1)
Set @importe=convert(decimal(18,4),SUBSTRING(@Data,@pos4+1,@pos5-@pos4-1))
Set @pos6 =Len(@Data)+1
Set @CompraId=convert(numeric(38),SUBSTRING(@Data,@pos5+1,@pos6-@pos5-1))
update DetalleCompra
set DetalleCantidad=@cantidad,PrecioCosto=@precioCosto,
DetalleDescuento=@Descuento,DetalleImporte=@importe
where DetalleId=@Id
select isnull((select STUFF ((select '¬'+convert(varchar,u.IdUm)+'|'+convert(varchar,u.IdProducto)+'|'+
u.UMDescripcion+'|'+CONVERT(VarChar(50), cast(u.ValorUM as money ), 1)+'|'+
convert(varchar,d.PrecioCosto)
from UnidadMedida u
inner join DetalleCompra d
on d.IdProducto=u.IdProducto
where d.CompraId=@CompraId
order by u.ValorUM asc
for xml path('')),1,1,'')),'true')
end
GO
/****** Object:  StoredProcedure [dbo].[editaDetaLiVenta]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editaDetaLiVenta]
@DetalleId numeric(38),
@EntidadBanco varchar(80),
@NroOperacion varchar(80),
@FechaPago varchar(60)
as
begin
update DetaLiquidaVenta
set EntidadBanco=@EntidadBanco,NroOperacion=@NroOperacion,FechaPago=@FechaPago
where DetalleId=@DetalleId
end
GO
/****** Object:  StoredProcedure [dbo].[editaDetalleNota]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editaDetalleNota]
@DetalleId numeric(38),
@IdProducto numeric(20),
@DetalleCantidad decimal(18,2),
@DetalleUM varchar(80),
@DetalleCosto decimal(18,2), 
@DetallePrecio decimal(18,2),
@DetalleImporte decimal(18,2),
@CantidadSaldo decimal(18,2),
@DetalleEstado varchar(60),
@DocuId numeric(38),
@ValorUM decimal(18,4)
as
begin
declare @guias int
set @guias=(select COUNT(d.IdDetalle)from DetalleGuia d where d.IdDetalle=@DetalleId)
begin
update DetallePedido
set DetalleCantidad=@DetalleCantidad,DetalleCosto=@DetalleCosto,
DetallePrecio=@DetallePrecio,DetalleImporte=@DetalleImporte,DetalleEstado=@DetalleEstado
where DetalleId=@DetalleId
if(@guias<=0)
begin
update DetallePedido
set CantidadSaldo=@CantidadSaldo
where DetalleId=@DetalleId
end
end
if(@DocuId<>'0')
begin
insert into DetalleDocumento values
(@DocuId,@IdProducto,@DetalleCantidad,@DetallePrecio,
@DetalleImporte,@DetalleId,@DetalleUM,@ValorUM)
end
end
GO
/****** Object:  StoredProcedure [dbo].[editaGuiacanje]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editaGuiacanje]
@CanjeId numeric(38),
@CompraId numeric(38),
@CompaniaId int,
@CanjeFecha date,
@CanjeRegistro datetime,
@CanjeSerie varchar(80),
@CanjeNumero varchar(80),
@CanjeEmision date,
@CanjeComputo date,
@CanjeCorrelativo varchar(80),
@CanjeTipo varchar(80),
@CanjeOBS varchar(max),
@TCSunat decimal(18,3),
@Usuario varchar(80),
@Subtotal decimal(18,2),
@Igv decimal(18,2),
@Total decimal(18,2)
as
begin
update GuiaCanje
set CompaniaId=@CompaniaId,CanjeFecha=@CanjeFecha,CanjeRegistro=@CanjeRegistro,
CanjeSerie=@CanjeSerie,CanjeNumero=@CanjeNumero,CanjeEmision=@CanjeEmision,CanjeComputo=@CanjeComputo,
CanjeCorrelativo=@CanjeCorrelativo,CanjeTipo=@CanjeTipo,CanjeOBS=@CanjeOBS,TCSunat=@TCSunat,CanjeUsuario=@Usuario
where CanjeId=@CanjeId
begin
update Compras
set CompaniaId=@CompaniaId,CompraSerie=@CanjeSerie,CompraNumero=@CanjeNumero,CompraEmision=@CanjeEmision,
CompraComputo=@CanjeComputo,CompraCorrelativo=@CanjeCorrelativo,CompraTipoIgv=@CanjeTipo,CompraOBS=@CanjeOBS,
CompraTipoSunat=@TCSunat,CompraUsuario=@Usuario,CompraSubtotal=@Subtotal,CompraIgv=@Igv,CompraTotal=@Total
where CompraId=@CompraId
end
end
GO
/****** Object:  StoredProcedure [dbo].[editaNotaLD]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editaNotaLD]
@Data varchar(max)
as
begin
declare @p0 int,
		@p1 int,
		@p2 int,
		@p3 int,
		@p4 int,
		@p5 int
declare @DetalleId numeric(38),
		@Cantidad decimal(18,2),
		@Costo decimal(18,2),
		@PrecioUni decimal(18,2),
		@Importe decimal(18,2),
		@Ganancia decimal(18,2),
		@NotaId numeric(38)		
Set @Data= LTRIM(RTrim(@Data))
set @p0 = CharIndex('|',@Data,0)
Set @p1 = CharIndex('|',@Data,@p0+1)
Set @p2 = CharIndex('|',@Data,@p1+1)
Set @p3 = CharIndex('|',@Data,@p2+1)
Set @p4 = CharIndex('|',@Data,@p3+1)
Set @p5=Len(@Data)+1
Set @DetalleId=Convert(numeric(38),SUBSTRING(@Data,1,@p0-1))
Set @Cantidad=Convert(decimal(18,2),SUBSTRING(@Data,@p0+1,@p1-(@p0+1)))
Set @Costo= Convert(decimal(18,2),SUBSTRING(@Data,@p1+1,@p2-(@p1+1)))
Set @PrecioUni= Convert(decimal(18,2),SUBSTRING(@Data,@p2+1,@p3-(@p2+1)))
Set @Importe= Convert(decimal(18,2),SUBSTRING(@Data,@p3+1,@p4-(@p3+1)))
Set @Ganancia= Convert(decimal(18,2),SUBSTRING(@Data,@p4+1,@p5-@p4-1))
set @NotaId=(select NotaId from DetallePedido where DetalleId=@DetalleId)
begin
	update DetallePedido 
	set DetalleCantidad=@Cantidad,DetalleCosto=@Costo,
	DetallePrecio=@PrecioUni,DetalleImporte=@Importe 
	where DetalleId=@DetalleId
	update NotaPedido
	set NotaGanancia=@Ganancia
	where NotaId=@NotaId
	select 'true'
end
end
GO
/****** Object:  StoredProcedure [dbo].[editaPrecioB]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editaPrecioB] 
@IdTabla numeric(38),
@IdProducto numeric(20),
@Aviso varchar(20),
@Accion varchar(20),
@UM varchar(80),
@valor decimal(18,4)
as
begin
declare @productoventaA decimal(18,2)
declare @productoventaB decimal(18,2)
if(@valor=1)
begin
set @productoventaA=(select top 1 p.ProductoVenta from Producto p where p.IdProducto=@IdProducto)
set @productoventaB=(select top 1 p.ProductoVentaB from Producto p where p.IdProducto=@IdProducto)
end
else
begin
set @productoventaA=isnull((select top 1 u.PrecioVenta from UnidadMedida u where u.IdProducto=@IdProducto and u.UMDescripcion=@UM),0)
set @productoventaB=isnull((select top 1 u.PrecioVentaB from UnidadMedida u where u.IdProducto=@IdProducto and u.UMDescripcion=@UM),0)
end
if(@Accion='T')
begin
if @Aviso='B'
begin
update TemporalVenta
set precioventa=@productoventaB,importe=cantidad*@productoventaB
where temporalId=@IdTabla
end
else
begin
update TemporalVenta
set precioventa=@productoventaA,importe=cantidad*@productoventaA
where temporalId=@IdTabla
end
end
else
begin
if @Aviso='B'
begin
update DetallePedido
set DetallePrecio=@productoventaB,DetalleImporte=DetalleCantidad*@productoventaB
where DetalleId=@IdTabla
end
else
begin
update DetallePedido
set DetallePrecio=@productoventaA,DetalleImporte=DetalleCantidad*@productoventaA
where DetalleId=@IdTabla
end
end
end
GO
/****** Object:  StoredProcedure [dbo].[editaProductoCosto]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editaProductoCosto] 
@IdProducto numeric(38),
@Costo decimal(18,4),
@Estado varchar(40),
@Condicion varchar(60),
@DescuentoB decimal(18,4),
@DetalleId numeric(38)
as
begin
if(@Estado<>'BONIFICACION')
begin
update Producto 
set ProductoCosto=@Costo
where IdProducto=@IdProducto 
if (@Condicion='NOTA CREDITO')
begin
update DetalleCompra
set DescuentoB=@DescuentoB
where DetalleId=@DetalleId
end
end
end
GO
/****** Object:  StoredProcedure [dbo].[editaprueba]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[editaprueba]
@ListaOrden varchar(Max)
as
begin
Declare @detalle varchar(max)
Set @detalle =@ListaOrden
Begin Transaction
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
        Declare @Columna varchar(max)
		declare @ClienteId numeric(20)
	    declare @ClienteUsuario varchar(80)
		Declare @p1 int
		declare @p2 int
Fetch Next From Tabla INTO @Columna
While @@FETCH_STATUS = 0
Begin
	    Set @p1 = CharIndex('|',@Columna,0)
		Set @p2 =Len(@Columna)+1
        Set @ClienteId=Convert(numeric(20),SUBSTRING(@Columna,1,@p1-1))
		Set @ClienteUsuario=SUBSTRING(@Columna,@p1+1,@p2-(@p1+1))
		update Cliente
		set ClienteUsuario=@ClienteUsuario+'  '+(IsNull(convert(varchar,GETDATE(),103),'')+' '+ IsNull(SUBSTRING(convert(varchar,getdate(),114),1,8),''))
		where ClienteId=@ClienteId
Fetch Next From Tabla INTO @Columna
End
	Close Tabla;
	Deallocate Tabla;
	Commit Transaction;
	Select 'true';
End
GO
/****** Object:  StoredProcedure [dbo].[editapruebaB]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editapruebaB]
@ListaOrden varchar(Max)
as
begin
Declare @detalle varchar(max)
Set @detalle =@ListaOrden
Begin Transaction
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
        Declare @Columna varchar(max)
		declare @DetalleId numeric(38)
	    declare @UM varchar(40)
		Declare @p1 int
		declare @p2 int
Fetch Next From Tabla INTO @Columna
While @@FETCH_STATUS = 0
Begin
	    Set @p1 = CharIndex('|',@Columna,0)
		Set @p2 =Len(@Columna)+1
        Set @DetalleId=Convert(numeric(38),SUBSTRING(@Columna,1,@p1-1))
		Set @UM=SUBSTRING(@Columna,@p1+1,@p2-(@p1+1))
		update DetalleGuia
		set UniMedida=@UM
		where DetalleId=@DetalleId
Fetch Next From Tabla INTO @Columna
End
	Close Tabla;
	Deallocate Tabla;
	Commit Transaction;
	Select 'true';
End
GO
/****** Object:  StoredProcedure [dbo].[editarCajaPri]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editarCajaPri]
@Data varchar(max)
as
begin
Declare @p1 int,@p2 int,
		@p3 int,@p4 int,
		@p5 int,@p6 int
declare @CajaConcepto varchar(80),
		@CajaDescripcion varchar(250),
		@CajaMonto decimal(18,2),
		@CajaUsuario varchar(20),
		@RutaImagen varchar(max),
		@IdCaja numeric(38)
Set @Data = LTRIM(RTrim(@Data))
		Set @p1 = CharIndex('|',@Data,0)
		Set @p2 = CharIndex('|',@Data,@p1+1)
		Set @p3 = CharIndex('|',@Data,@p2+1)
		Set @p4 = CharIndex('|',@Data,@p3+1)
		Set @p5= CharIndex('|',@Data,@p4+1)
		Set @p6= Len(@Data)+1
		Set @CajaConcepto=SUBSTRING(@Data,1,@p1-1)
		Set @CajaDescripcion=SUBSTRING(@Data,@p1+1,@p2-@p1-1)
		Set @CajaMonto=convert(decimal(18,2),SUBSTRING(@Data,@p2+1,@p3-@p2-1))
		Set @CajaUsuario=SUBSTRING(@Data,@p3+1,@p4-@p3-1)
		Set @RutaImagen=SUBSTRING(@Data,@p4+1,@p5-@p4-1)
		Set @IdCaja=convert(numeric(38),SUBSTRING(@Data,@p5+1,@p6-@p5-1))		
update CajaPincipal
set CajaConcepto=@CajaConcepto,CajaFecha=GETDATE(),
CajaDescripcion=@CajaDescripcion,CajaMonto=@CajaMonto,
RutaImagen=@RutaImagen,CajaUsuario=@CajaUsuario
where IdCaja=@IdCaja
select isnull((select STUFF((select '¬'+ convert(varchar,c.IdCaja)+'|'+c.CajaConcepto+'|'+convert(varchar,c.CajaId)+'|'+
Convert(char(10),c.CajaFecha,103)+' '+Convert(char(8),c.CajaFecha,114) 
+'|'+c.CajaDescripcion+'|'+CONVERT(VarChar(50),cast(c.CajaMonto as money), 1)+'|'+
c.CajaUsuario+'|'+c.RutaImagen  
from CajaPincipal c 
where c.CajaConcepto='INGRESO' and c.IdGeneral=0
order by c.IdCaja desc
for xml path('')),1,1,'')),'~')+'['+
isnull((select STUFF((select '¬'+ convert(varchar,c.IdCaja)+'|'+c.CajaConcepto+'|'+convert(varchar,c.CajaId)+'|'+
Convert(char(10),c.CajaFecha,103)+' '+Convert(char(8),c.CajaFecha,114) 
+'|'+c.CajaDescripcion+'|'+CONVERT(VarChar(50),cast(c.CajaMonto as money), 1)+'|'+
c.CajaUsuario+'|'+c.RutaImagen  
from CajaPincipal c 
where c.CajaConcepto='SALIDA' and c.IdGeneral=0
order by c.IdCaja desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[editarCanje]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editarCanje]
@temporalId numeric(38),
@temporalCanje varchar(80),
@temporalDias int,
@temporalVencimiento varchar(20),
@temporalMonto decimal(18,2)
as
begin
update TemporalCanje
set temporalCanje=@temporalCanje,temporalDias=@temporalDias,
temporalVencimiento=@temporalVencimiento,temporalMonto=@temporalMonto
where temporalId=@temporalId
end
GO
/****** Object:  StoredProcedure [dbo].[editarCompania]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editarCompania]
@CompaniaId int,
@CompaniaRazonSocial varchar(140),
@CompaniaRUC varchar(20),
@CompaniaDireccion varchar(max),
@CompaniaTelefono varchar(80),
@CompaniaEmail varchar(100),
@CompaniaIniFecha varchar(100)
as
begin
update Compania
set CompaniaRazonSocial=@CompaniaRazonSocial,
CompaniaRUC=@CompaniaRUC,CompaniaDireccion=@CompaniaDireccion,
CompaniaTelefono=@CompaniaTelefono,CompaniaEmail=@CompaniaEmail,
CompaniaIniFecha=@CompaniaIniFecha
where CompaniaId=@CompaniaId
end
GO
/****** Object:  StoredProcedure [dbo].[editarCompra]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editarCompra]
@CompraId numeric(38),
@CompaniaId int,
@CompraCorrelativo varchar(80),
@ProveedorId numeric(38),
@CompraEmision date,
@CompraComputo date,
@TipoCodigo char(20),
@CompraSerie varchar(60),
@CompraNumero varchar(80),
@CompraCondicion varchar(60),
@CompraMoneda varchar(60),
@CompraTipoCambio decimal(18,3),
@CompraDias int,
@CompraFechaPago date,
@CompraUsuario varchar(80),
@CompraTipoIgv varchar(60),
@CompraValorVenta decimal(18,2),
@CompraDescuento decimal(18,2),
@CompraSubtotal decimal(18,2),
@CompraIgv decimal(18,2),
@CompraTotal decimal(18,2),
@CompraEstado varchar(60),
@CompraAsociado varchar(60),
@compraSaldo decimal(18,2),
@CompraOBS varchar(max),
@CompraTipoSunat decimal(18,3),
@CompraPercepcion decimal(18,2)
as 
begin
update Compras
set CompaniaId=@CompaniaId,CompraCorrelativo=@CompraCorrelativo,ProveedorId=@ProveedorId,CompraEmision=@CompraEmision,CompraComputo=@CompraComputo,
TipoCodigo=@TipoCodigo,CompraSerie=@CompraSerie,CompraNumero=@CompraNumero,CompraCondicion=@CompraCondicion,
CompraMoneda=@CompraMoneda,CompraTipoCambio=@CompraTipoCambio,CompraDias=@CompraDias,CompraFechaPago=@CompraFechaPago,
CompraUsuario=@CompraUsuario,CompraTipoIgv=@CompraTipoIgv,CompraValorVenta=@CompraValorVenta,
CompraDescuento=@CompraDescuento,CompraSubtotal=@CompraSubtotal,CompraIgv=@CompraIgv,CompraTotal=@CompraTotal,
CompraEstado=@CompraEstado,CompraAsociado=@CompraAsociado,CompraSaldo=@compraSaldo,CompraOBS=@CompraOBS,
CompraTipoSunat=@CompraTipoSunat,CompraPercepcion=@CompraPercepcion
where CompraId=@CompraId
end
GO
/****** Object:  StoredProcedure [dbo].[editarDetaLiquida]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editarDetaLiquida]
@DetalleId numeric(38),
@EntidadBanco varchar(80),
@NroOperacion varchar(80),
@FechaPago varchar(60)
as
begin
update DetalleLiquida
set EntidadBanco=@EntidadBanco,NroOperacion=@NroOperacion,FechaPago=@FechaPago
where DetalleId=@DetalleId
end
GO
/****** Object:  StoredProcedure [dbo].[editarGuia]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editarGuia]
@GuiaId numeric(38),
@GuiaNumero varchar(60),
@GuiaMotivo varchar(80),
@GuiaFechaTraslado datetime,
@GuiaDestinatario varchar(250),
@GuiaRucDes varchar(60),
@GuiaAlmacen varchar(80),
@GuiaPartida varchar(max),
@GuiaLLegada varchar(max),
@GuiaTramsporte varchar(80),
@GuiaTransporteRuc varchar(20),
@GuiaChofer varchar(80),
@GuiaPlaca varchar(80),
@GuiaConstancia varchar(80),
@GuiaLicencia varchar(80),
@GuiaUsuario varchar(80),
@GuiaTotal decimal(18,2),
@ClienteId numeric(20),
@GuiaTelefono varchar(80)
as
begin
update GuiaRemision
set GuiaNumero=@GuiaNumero,GuiaMotivo=@GuiaMotivo,GuiaFechaTraslado=@GuiaFechaTraslado,
GuiaDestinatario=@GuiaDestinatario,GuiaRucDes=@GuiaRucDes,GuiaAlmacen=@GuiaAlmacen,
GuiaPartida=@GuiaPartida,GuiaLLegada=@GuiaLLegada,GuiaTramsporte=@GuiaTramsporte,
GuiaTransporteRuc=@GuiaTransporteRuc,GuiaChofer=@GuiaChofer,GuiaPlaca=@GuiaPlaca,
GuiaConstancia=@GuiaConstancia,GuiaLicencia=@GuiaLicencia,GuiaUsuario=@GuiaUsuario,GuiaTotal=@GuiaTotal,
ClienteId=@ClienteId,GuiaTelefono=@GuiaTelefono
where GuiaId=@GuiaId
end
GO
/****** Object:  StoredProcedure [dbo].[editarLiquida]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editarLiquida]
@LiquidacionId numeric(38),
@LiquidacionRegistro datetime,
@LiquidacionFecha date,
@LiquidacionDescripcion varchar(250),
@LiquidacionCambio decimal(18,3),
@LiquidaEfectivoSol decimal(18,2),
@LiquidaDepositoSol decimal(18,2),
@LiquidaTotalSol decimal(18,2),
@LiquidaEfectivoDol decimal(18,2),
@LiquidaDepositoDol decimal(18,2),
@LiquidaTotalDol decimal(18,2),
@LiquidaUsuario varchar(60)
as
begin
update Liquidacion
set LiquidacionRegistro=@LiquidacionRegistro,LiquidacionFecha=@LiquidacionFecha,
LiquidacionDescripcion=@LiquidacionDescripcion,LiquidacionCambio=@LiquidacionCambio,
LiquidaEfectivoSol=@LiquidaEfectivoSol,LiquidaDepositoSol=@LiquidaDepositoSol,
LiquidaTotalSol=@LiquidaTotalSol,LiquidaEfectivoDol=@LiquidaEfectivoDol,
LiquidaDepositoDol=@LiquidaDepositoDol,LiquidaTotalDol=@LiquidaTotalDol,
LiquidaUsuario=@LiquidaUsuario
where LiquidacionId=@LiquidacionId
end
GO
/****** Object:  StoredProcedure [dbo].[editarLiquidaVenta]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editarLiquidaVenta]
@LiquidacionId numeric(38),
@LiquidacionRegistro datetime,
@LiquidacionFecha date,
@LiquidacionDescripcion varchar(250),
@LiquidacionCambio decimal(18,3),
@LiquidaEfectivoSol decimal(18,2),
@LiquidaDepositoSol decimal(18,2),
@LiquidaTotalSol decimal(18,2),
@LiquidaEfectivoDol decimal(18,2),
@LiquidaDepositoDol decimal(18,2),
@LiquidaTotalDol decimal(18,2),
@LiquidaUsuario varchar(60)
as
begin
update LiquidacionVenta
set LiquidacionRegistro=@LiquidacionRegistro,LiquidacionFecha=@LiquidacionFecha,
LiquidacionDescripcion=@LiquidacionDescripcion,LiquidacionCambio=@LiquidacionCambio,
LiquidaEfectivoSol=@LiquidaEfectivoSol,LiquidaDepositoSol=@LiquidaDepositoSol,
LiquidaTotalSol=@LiquidaTotalSol,LiquidaEfectivoDol=@LiquidaEfectivoDol,
LiquidaDepositoDol=@LiquidaDepositoDol,LiquidaTotalDol=@LiquidaTotalDol,
LiquidaUsuario=@LiquidaUsuario
where LiquidacionId=@LiquidacionId
end
GO
/****** Object:  StoredProcedure [dbo].[editarNOta]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editarNOta]
@NotaId numeric(38),
@NotaDocu varchar(60),
@ClienteId numeric(20),
@NotaFecha datetime,
@NotaUsuario varchar(60),
@NotaSubtotal decimal(8,2),
@NotaDescuento decimal(18,2),
@NotaTotal decimal(18,2),
@NotaEstado varchar(60)
as
begin
update NotaPedido
set NotaDocu=@NotaDocu,ClienteId=@ClienteId,NotaFecha=@NotaFecha,NotaUsuario=@NotaUsuario,NotaSubtotal=@NotaSubtotal,NotaDescuento=@NotaDescuento,NotaTotal=@NotaTotal,NotaEstado=@NotaEstado
where NotaId=@NotaId
end
GO
/****** Object:  StoredProcedure [dbo].[editarPersonal]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editarPersonal]
@PersonalId numeric(20),
@PersonalNombres varchar(140),
@PersonalApellidos varchar(140),
@AreaId numeric(20),
@PersonalCodigo varchar (80),
@PersonalNacimiento date,
@PersonalIngreso varchar(20),
@PersonalDNI varchar(20),
@PersonalDireccion varchar(140),
@PersonalTelefono varchar(40),
@PersonalTelefonoAsi varchar(40),
@PersonalEmail varchar(100),
@PersonalSueldo decimal(18,2),
@PersonalEstado varchar(60),
@PersonalBajaFecha varchar(60),
@PersonalRuc varchar(20),
@PersonalImagen varchar(max),
@CompaniaId int,
@HoraIngreso time
as
begin
update Personal
set PersonalNombres=@PersonalNombres,PersonalApellidos=@PersonalApellidos,AreaId=@AreaId,PersonalCodigo=@PersonalCodigo,PersonalNacimiento=@PersonalNacimiento,
PersonalIngreso=@PersonalIngreso,PersonalDNI=@PersonalDNI,PersonalDireccion=@PersonalDireccion,PersonalTelefono=@PersonalTelefono,
PersonalTelefonoAsi=@PersonalTelefonoAsi,PersonalEmail=@PersonalEmail,PersonalSueldo=@PersonalSueldo,PersonalEstado=@PersonalEstado,
PersonalBajaFecha=@PersonalBajaFecha,PersonalRuc=@PersonalRuc,PersonalImagen=@PersonalImagen,CompaniaId=@CompaniaId,
HoraIngreso=@HoraIngreso
where PersonalId=@PersonalId
end
GO
/****** Object:  StoredProcedure [dbo].[editarProducto]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editarProducto]
 @IdProducto numeric(20),
 @IdSubLinea numeric(20),
 @ProductoCodigo varchar(300),
 @ProductoNombre varchar(300),
 @ProductoUM varchar(60),
 @ProductoCosto decimal(18,4),
 @ProductoVenta decimal(18,2),
 @ProductoVentaB decimal(18,2),
 @ProductoCantidad decimal(18,2),
 @ProductoEstado varchar(60),
 @ProductoUsuario varchar(60),
 @ProductoImagen varchar(max),
 @ValorCritico decimal(18,2),
 @AVISO INT
 as
 declare @inicial decimal(18,2)
 set @inicial=(select p.ProductoCantidad from Producto p where IdProducto=@IdProducto)
 if(@AVISO=1)
 begin
 begin Tran
 update Producto
 set IdSubLinea=@IdSubLinea,ProductoCodigo=@ProductoCodigo,ProductoNombre=@ProductoNombre,
 ProductoUM=@ProductoUM,ProductoCosto=@ProductoCosto,ProductoVenta=@ProductoVenta,
 ProductoVentaB=@ProductoVentaB,ProductoEstado=@ProductoEstado,
 ProductoUsuario=@ProductoUsuario,ProductoFecha=GETDATE(),ProductoImagen=@ProductoImagen,ValorCritico=@ValorCritico
 where IdProducto=@IdProducto
 insert into Kardex values(@IdProducto,GETDATE(),'Edita Costo','Edita Costo',@inicial,0,0,@ProductoCosto,@inicial,'INGRESO',@ProductoUsuario)
 commit tran
 end
 else
 begin
 begin tran
 update Producto
 set IdSubLinea=@IdSubLinea,ProductoCodigo=@ProductoCodigo,ProductoNombre=@ProductoNombre,
 ProductoUM=@ProductoUM,ProductoCosto=@ProductoCosto,ProductoVenta=@ProductoVenta,
 ProductoVentaB=@ProductoVentaB,ProductoCantidad=@ProductoCantidad,ProductoEstado=@ProductoEstado,
 ProductoUsuario=@ProductoUsuario,ProductoFecha=GETDATE(),ProductoImagen=@ProductoImagen,ValorCritico=@ValorCritico
 where IdProducto=@IdProducto
 insert into Kardex values(@IdProducto,GETDATE(),'Edita Cantidad','Edita Cantidad',@inicial,0,0,@ProductoCosto,@ProductoCantidad,'INGRESO',@ProductoUsuario)
 commit tran
 end
GO
/****** Object:  StoredProcedure [dbo].[editarTemLiquida]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editarTemLiquida] 
@TemporalId numeric(38),
@EfectivoSoles decimal(18,2),
@EfectivoDolar decimal(18,2),
@DepositoSoles decimal(18,2),
@DepositoDolar decimal(18,2),
@TipoCambio decimal(18,3),
@EntidadBanco varchar(80),
@NroOperacion varchar(80),
@AcuentaGeneral decimal(18,2),
@TemporalFecha varchar(60)
as
begin
update TemporalLiquida
set EfectivoSoles=@EfectivoSoles,EfectivoDolar=@EfectivoDolar,
DepositoSoles=@DepositoSoles,DepositoDolar=@DepositoDolar,
TipoCambio=@TipoCambio,EntidadBanco=@EntidadBanco,NroOperacion=@NroOperacion,
AcuentaGeneral=@AcuentaGeneral,TemporalFecha=@TemporalFecha
where TemporalId=@TemporalId
end
GO
/****** Object:  StoredProcedure [dbo].[editarTemLiVenta]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editarTemLiVenta] 
@TemporalId numeric(38),
@EfectivoSoles decimal(18,2),
@EfectivoDolar decimal(18,2),
@DepositoSoles decimal(18,2),
@DepositoDolar decimal(18,2),
@TipoCambio decimal(18,3),
@EntidadBanco varchar(80),
@NroOperacion varchar(80),
@AcuentaGeneral decimal(18,2),
@TemporalFecha varchar(60)
as
begin
update TemporalLiVenta
set EfectivoSoles=@EfectivoSoles,EfectivoDolar=@EfectivoDolar,
DepositoSoles=@DepositoSoles,DepositoDolar=@DepositoDolar,
TipoCambio=@TipoCambio,EntidadBanco=@EntidadBanco,NroOperacion=@NroOperacion,
AcuentaGeneral=@AcuentaGeneral,TemporalFecha=@TemporalFecha
where TemporalId=@TemporalId
end
GO
/****** Object:  StoredProcedure [dbo].[editarUsuario]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editarUsuario] 
@UsuarioId int,
@UsuarioAlias varchar(60),
@UsuarioClave varchar(40),
@UsuarioFechaReg datetime,
@UsuarioEstado varchar(40)
as
begin
update Usuarios 
set UsuarioAlias=@UsuarioAlias,UsuarioClave=dbo.encriptar(@UsuarioClave),UsuarioFechaReg=@UsuarioFechaReg,Usuarioestado=@UsuarioEstado
where UsuarioID=@UsuarioId
end
GO
/****** Object:  StoredProcedure [dbo].[eliminaBloqueB]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminaBloqueB]
@ListaOrden varchar(Max),
@PKardex varchar(max)
as
begin
Declare @pos int
	Set @pos = CharIndex('_',@ListaOrden,0)
	Declare @BloqueId varchar(max)
	Declare @detalle varchar(max)
	Set @BloqueId=SUBSTRING(@ListaOrden,1,@pos-1)
	Set @detalle =SUBSTRING(@ListaOrden,@pos+1,len(@ListaOrden)-@pos)
Begin Transaction
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
        Declare @Columna varchar(max)
		declare @NotaId numeric(38)
		Declare @ps1 int
Fetch Next From Tabla INTO @Columna
While @@FETCH_STATUS = 0
Begin
	    Set @NotaId=@Columna
		update NotaPedido
        set NotaEstado='PENDIENTE',NotaSaldo=NotaPagar,NotaAcuenta=0
        where NotaId=@NotaId
        delete from CajaDetalle
        where NotaId=@NotaId
Fetch Next From Tabla INTO @Columna
End
	Close Tabla;
	Deallocate Tabla;
	begin
	DECLARE @Kardex VARCHAR(MAX)
    Set @Kardex =@PKardex
	Declare TablaB Cursor For Select * From fnSplitString(@Kardex,';')	
Open TablaB
		Declare @ColumnaB varchar(max),
		@IdProducto numeric(20),
		@Documento varchar(150),
		@CantIngreso decimal(18,2),
		@PrecioCosto decimal(18,4),
		@Usuario varchar(80)
		Declare @p1 int
		Declare @p2 int
		Declare @p3 int
		declare @p4 int
		declare @p5 int
		declare @IniciaStock decimal(18,2),@StockFinal decimal(18,2)
Fetch Next From TablaB INTO @ColumnaB
	While @@FETCH_STATUS = 0
	Begin
		Set @p1 = CharIndex('|',@ColumnaB,0)
		Set @p2 = CharIndex('|',@ColumnaB,@p1+1)
		Set @p3 = CharIndex('|',@ColumnaB,@p2+1)
		Set @p4 = CharIndex('|',@ColumnaB,@p3+1)
		Set @p5 =Len(@ColumnaB)+1
        Set @IdProducto=Convert(numeric(20),SUBSTRING(@ColumnaB,1,@p1-1))
		Set @Documento= Convert(varchar(150),SUBSTRING(@ColumnaB,@p1+1,@p2-(@p1+1)))
		Set @CantIngreso= Convert(varchar(80),SUBSTRING(@ColumnaB,@p2+1,@p3-(@p2+1)))
		Set @PrecioCosto= Convert(varchar(80),SUBSTRING(@ColumnaB,@p3+1,@p4-(@p3+1)))
		Set @Usuario= Convert(varchar(80),SUBSTRING(@ColumnaB,@p4+1,@p5-@p4-1))
		set @IniciaStock=(select top 1 ProductoCantidad from Producto (nolock) where IdProducto=@IdProducto)
		set @StockFinal=@IniciaStock+@CantIngreso
		insert into Kardex values(@IdProducto,GETDATE(),'Anulacion por Venta',@Documento,@IniciaStock,
		@CantIngreso,0,@PrecioCosto,@StockFinal,'INGRESO',@Usuario)
		update producto 
	    set  ProductoCantidad =ProductoCantidad+@CantIngreso
	    where IDProducto=@IdProducto
		Fetch Next From TablaB INTO @ColumnaB
	End
	Close TablaB;
	Deallocate TablaB;
	delete from DetalleBloque
	where BloqueId=@BloqueId
	delete from BLOQUE
	where BloqueId=@BloqueId
end
	Commit Transaction;
	Select 'true';
End
GO
/****** Object:  StoredProcedure [dbo].[eliminaCuenta]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminaCuenta]
@Data varchar(max)
as
begin
    Set @Data = LTRIM(RTrim(@Data))
	Declare @pos1 int,@pos2 int
	declare @CuentaId numeric(38),@ProveedorId numeric(38)
	declare @contador int
Set @pos1 = CharIndex('|',@Data,0)
Set @CuentaId=convert(numeric(38),SUBSTRING(@Data,1,@pos1-1))
Set @pos2 =Len(@Data)+1
Set @ProveedorId=convert(numeric(38),SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))
	delete from CuentaProveedor
	where CuentaId=@CuentaId
set @contador=(select COUNT(*) from CuentaProveedor where ProveedorId=@ProveedorId)	
if 	@contador<=0
begin
	select 'true'
end
else
begin
	select isnull((select STUFF ((select '¬'+ CONVERT(varchar,c.CuentaId)+'|'+c.Entidad+'|'+
	c.TipoCuenta+'|'+c.Moneda+'|'+c.NroCuenta
	from CuentaProveedor c
	where c.ProveedorId=@ProveedorId
	order by c.CuentaId desc
	for xml path('')),1,1,'')),'~')
end
end
GO
/****** Object:  StoredProcedure [dbo].[eliminaDetaCaja]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminaDetaCaja]
@DetalleId numeric(38),
@NotaId numeric(38),
@Monto decimal(18,2)
as
begin
declare @Acuenta decimal(18,2),@Documento varchar(40),@EstadoDocu varchar(80)
declare @Data varchar(60)
declare @p1 int,@p2 int
update NotaPedido
set NotaSaldo=NotaSaldo + @Monto,NotaAcuenta=NotaAcuenta-@Monto
where NotaId=@NotaId
set @Acuenta=(select NotaAcuenta from NotaPedido where NotaId=@NotaId)
set @Data=isnull((select top 1 d.DocuDocumento+'¬'+d.DocuEstado from DocumentoVenta d where d.NotaId=@NotaId order by DocuId desc),'0¬0')
Set @Data = LTRIM(RTrim(@Data))
Set @p1 = CharIndex('¬',@Data,0)
Set @p2 = Len(@Data)+1
Set @Documento=SUBSTRING(@Data,1,@p1-1)
Set @EstadoDocu=SUBSTRING(@Data,@p1+1,@p2-@p1-1)
if @EstadoDocu='ANULADO'
begin
update NotaPedido 
set NotaEstado='ANULADO'
where NotaId=@NotaId
end
else
begin
if(@Documento='FACTURA' or @Documento='BOLETA')
begin
if @Acuenta<=0
begin
update NotaPedido 
set NotaEstado='EMITIDO'
where NotaId=@NotaId
end
else
begin
update NotaPedido 
set NotaEstado='ACUENTA'
where NotaId=@NotaId
end
END
else
begin
if @Acuenta<=0
begin
update NotaPedido 
set NotaEstado='PENDIENTE'
where NotaId=@NotaId
end
else
begin
update NotaPedido 
set NotaEstado='ACUENTA'
where NotaId=@NotaId
end
end
end
delete from CajaDetalle 
where DetalleId=@DetalleId
end
GO
/****** Object:  StoredProcedure [dbo].[eliminaDetaCajaB]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminaDetaCajaB]
@Data varchar(max)
as
begin
Declare @p1 int,
        @p2 int
Declare @DetalleId numeric(38),
		@CajaId numeric(38)
Set @Data = LTRIM(RTrim(@Data))
Set @p1 = CharIndex('|',@Data,0)
Set @p2 = Len(@Data)+1
Set @DetalleId =convert(numeric(38),SUBSTRING(@Data,1,@p1-1))
Set @CajaId =convert(numeric(38),SUBSTRING(@Data,@p1+1,@p2-@p1-1))
delete from CajaDetalle 
where DetalleId=@DetalleId
begin
select isnull((select stuff((select '¬'+
	convert(varchar,d.DetalleId)+'|'+convert(varchar,d.CajaId)+'|'+
	(IsNull(convert(varchar,d.DetalleFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,d.DetalleFecha,114),1,8),''))+'|'+
	convert(varchar,d.NotaId)+'|'+d.DetalleMovimiento+'|'+d.DetalleReferencia+'|'+d.DetalleConcepto+'|'+d.DetalleMoneda+'|'+convert(varchar,d.DetalleTipoCambio)+'|'+
	CONVERT(VarChar(50), cast(d.DetalleEfectivo as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(d.DetalleMonto as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(d.DetalleVuelto as money ), 1)+'|'+
	convert(varchar,d.DetalleEfectivo)+'|'+ISNULL(n.NotaEntrega,'INMEDIATA')
	from CajaDetalle d
	left join NotaPedido n
	on n.NotaId=d.NotaId
	where d.CajaId=@CajaId
	order by d.DetalleId desc
	for xml path('')),1,1,'')),'~')+'['+ 
isnull((select STUFF((select '¬'+p.ProductoCodigo+'|'+
d.DetalleDescripcion+'|'+
CONVERT(VarChar(50), cast(SUM(d.DetalleCantidad) as money ), 1)+'|'+d.DetalleUm+'|'+
CONVERT(VarChar(50), cast(SUM(d.DetalleImporte) as money ), 1)
from NotaPedido n
inner join DetallePedido d
on d.NotaId=n.NotaId
inner join Producto p
on p.IdProducto=d.IdProducto
where CajaId=@CajaId and(n.NotaEstado='CANCELADO' and n.NotaConcepto='MERCADERIA')
group by p.ProductoCodigo,d.DetalleDescripcion,d.DetalleUm
order by p.ProductoCodigo asc
for xml path('')),1,1,'')),'~')
end
end
GO
/****** Object:  StoredProcedure [dbo].[eliminaDetaLiquida]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminaDetaLiquida] 
@DetalleId numeric(38),
@CompraId numeric(18,2),
@Acuenta decimal(18,2),
@Concepto varchar(40)
as
begin
if(@Concepto='LETRA')
begin
update DetalleLetra
set DetalleSaldo=DetalleSaldo+@Acuenta,DetalleEstado='PENDIENTE DE PAGO'
where DetalleId=@CompraId
end
else
begin
update Compras
set CompraSaldo=CompraSaldo+@Acuenta,CompraEstado='PENDIENTE DE PAGO'
where CompraId=@CompraId
end
begin
delete from DetalleLiquida
where DetalleId=@DetalleId
end
end
GO
/****** Object:  StoredProcedure [dbo].[eliminaDetaLiVenta]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminaDetaLiVenta] @DetalleId numeric(38),@DocuId numeric(38),@NotaId numeric(38),@Acuenta decimal(18,2)
as
BEGIN TRANSACTION
update DocumentoVenta
set DocuSaldo=DocuSaldo+@Acuenta,DocuEstado='EMITIDO'
where DocuId=@DocuId
update NotaPedido
set NotaSaldo=NotaSaldo + @Acuenta,NotaEstado='EMITIDO'
where NotaId=@NotaId
delete from DetaLiquidaVenta
where DetalleId=@DetalleId
commit
GO
/****** Object:  StoredProcedure [dbo].[eliminaDetaNota]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[eliminaDetaNota]
@Data varchar(max)
as
begin
declare @p0 int, 
        @p1 int
declare @DetalleId numeric(38),
        @Ganancia decimal(18,2),
        @NotaId numeric(38)
Set @Data= LTRIM(RTrim(@Data))
set @p0 = CharIndex('|',@Data,0)
Set @p1 = Len(@Data)+1
Set @DetalleId=Convert(numeric(38),SUBSTRING(@Data,1,@p0-1))
Set @Ganancia= Convert(decimal(18,2),SUBSTRING(@Data,@p0+1,@p1-@p0-1))
set @NotaId=(select NotaId from DetallePedido where DetalleId=@DetalleId)
begin
	delete from DetallePedido 
	where DetalleId=@DetalleId
	update NotaPedido
	set NotaGanancia=NotaGanancia-@Ganancia
	where NotaId=@NotaId
	select 'true'
end
end
GO
/****** Object:  StoredProcedure [dbo].[eliminaGuiaRe]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[eliminaGuiaRe]
@GuiaId numeric(38),
@NotaId numeric(38)
as
begin
begin
update GuiaRemision
set GuiaEstado=''
where GuiaId=@GuiaId
end
begin
delete from GuiaRelacion
where NotaId=@NotaId
end
end
GO
/****** Object:  StoredProcedure [dbo].[eliminaliquiVenta]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminaliquiVenta] 
@LiquidacionId numeric(38),
@NotaId numeric(38),
@Acuenta decimal(18,2)
as
update NotaPedido
set NotaSaldo=NotaSaldo + @Acuenta,NotaEstado='EMITIDO'
where NotaId=@NotaId
delete from DetaLiquidaVenta
where LiquidacionId=@LiquidacionId
delete from LiquidacionVenta
where LiquidacionId=@LiquidacionId
GO
/****** Object:  StoredProcedure [dbo].[eliminarCajaPrin]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[eliminarCajaPrin]
@Data varchar(max)
as
begin
Declare @p1 int
Declare @IdCaja numeric(38)
Set @Data = LTRIM(RTrim(@Data))
Set @p1= Len(@Data)+1
Set @IdCaja=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))
begin
delete from CajaPincipal 
where IdCaja=@IdCaja
select isnull((select STUFF((select '¬'+ convert(varchar,c.IdCaja)+'|'+c.CajaConcepto+'|'+convert(varchar,c.CajaId)+'|'+
Convert(char(10),c.CajaFecha,103)+' '+Convert(char(8),c.CajaFecha,114) 
+'|'+c.CajaDescripcion+'|'+CONVERT(VarChar(50),cast(c.CajaMonto as money), 1)+'|'+
c.CajaUsuario+'|'+c.RutaImagen  
from CajaPincipal c 
where c.CajaConcepto='INGRESO' and c.IdGeneral=0
order by c.IdCaja desc
for xml path('')),1,1,'')),'~')+'['+
isnull((select STUFF((select '¬'+ convert(varchar,c.IdCaja)+'|'+c.CajaConcepto+'|'+convert(varchar,c.CajaId)+'|'+
Convert(char(10),c.CajaFecha,103)+' '+Convert(char(8),c.CajaFecha,114) 
+'|'+c.CajaDescripcion+'|'+CONVERT(VarChar(50),cast(c.CajaMonto as money), 1)+'|'+
c.CajaUsuario+'|'+c.RutaImagen 
from CajaPincipal c 
where c.CajaConcepto='SALIDA' and c.IdGeneral=0
order by c.IdCaja desc
for xml path('')),1,1,'')),'~')
end
end
GO
/****** Object:  StoredProcedure [dbo].[eliminarCanje]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminarCanje]
@CanjeId numeric(38),@CompraId numeric(38),@GTCSunat decimal(18,3),
@GCompania int,@GSerie varchar(80),
@GNumero varchar(80),@GEmision date,
@GComputo date,@GCorrelativo varchar(80),
@GTipo varchar(80),@GOBS varchar(max),
@Usuario varchar(60),@Monto decimal(18,2)
as
declare @Subtotal decimal(18,2),@Igv decimal(18,2),@Total decimal(18,2)
IF @GTipo ='DISGREGADO'
begin
set @Subtotal=@Monto
set @Igv=@Subtotal * 0.18
set @Total=@Subtotal + @Igv
end   
ELSE If @GTipo='INCLUIDO'
begin
set @Subtotal=@Monto/1.18
set @Igv=@Monto-(@Monto/1.18)
set @Total=@Monto
end
Else
begin
set @Subtotal=@Monto
set @Igv=0
set @Total=@Monto
end
begin
update Compras
set CompaniaId=@GCompania,CompraTipoSunat=@GTCSunat,CompraSerie=@GSerie,CompraNumero=@GNumero,CompraEmision=@GEmision,
CompraComputo=@GComputo,CompraCorrelativo=@GCorrelativo,CompraTipoIgv=@GTipo,CompraOBS=@GOBS,TipoCodigo='09',CompraUsuario=@Usuario,
CompraSubtotal=@Subtotal,CompraIgv=@Igv,CompraTotal=@Total
where CompraId=@CompraId
begin
delete from GuiaCanje
where CanjeId=@CanjeId
end
end
GO
/****** Object:  StoredProcedure [dbo].[eliminarCompra]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminarCompra] 
@CompraId numeric(38)
as
begin
delete from DetalleCompra 
where CompraId=@CompraId
end
begin
delete from Compras
where CompraId=@CompraId
end
GO
/****** Object:  StoredProcedure [dbo].[eliminarDocumento]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminarDocumento]
@DocuId numeric(38)
as
begin
delete from DetalleDocumento 
where DocuId=@DocuId
end
begin
delete from DocumentoVenta
where DocuId=@DocuId
end
GO
/****** Object:  StoredProcedure [dbo].[eliminarGeneral]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[eliminarGeneral]
@Data varchar(max)
as
begin
Declare @IdGeneral numeric(38)
set @IdGeneral=@Data
	delete from CajaGeneral
	where IdGeneral=@IdGeneral
	update CajaPincipal
	set IdGeneral=0
	where IdGeneral=@IdGeneral
end
begin
select isnull((select STUFF((select '¬'+ convert(varchar,c.IdCaja)+'|'+c.CajaConcepto+'|'+convert(varchar,c.CajaId)+'|'+
Convert(char(10),c.CajaFecha,103)+' '+Convert(char(8),c.CajaFecha,114) 
+'|'+c.CajaDescripcion+'|'+CONVERT(VarChar(50),cast(c.CajaMonto as money), 1)+'|'+
c.CajaUsuario+'|'+c.RutaImagen
from CajaPincipal c 
where c.CajaConcepto='INGRESO' and c.IdGeneral=0
order by c.IdCaja desc
for xml path('')),1,1,'')),'~')+'['+
isnull((select STUFF((select '¬'+ convert(varchar,c.IdCaja)+'|'+c.CajaConcepto+'|'+convert(varchar,c.CajaId)+'|'+
Convert(char(10),c.CajaFecha,103)+' '+Convert(char(8),c.CajaFecha,114) 
+'|'+c.CajaDescripcion+'|'+CONVERT(VarChar(50),cast(c.CajaMonto as money), 1)+'|'+
c.CajaUsuario+'|'+c.RutaImagen
from CajaPincipal c 
where c.CajaConcepto='SALIDA' and c.IdGeneral=0
order by c.IdCaja desc
for xml path('')),1,1,'')),'~')+'['+
isnull((select STUFF ((select '¬'+ CONVERT(varchar,c.IdGeneral)+'|'+
(IsNull(convert(varchar,c.FechaCierre,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,c.FechaCierre,114),1,8),''))+'|'+c.Usuario+'|'+
CONVERT(varchar(50),cast(c.Ingresos as money),1)+'|'+CONVERT(varchar(50),cast(c.Salidas as money),1)+'|'+
CONVERT(varchar(50),cast(c.Total as money),1)
from CajaGeneral c
order by c.IdGeneral desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[eliminarGuia]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminarGuia] 
@GuiaId numeric(38)
as
begin
delete from DetalleGuia
where GuiaId=@GuiaId
end
begin
delete from GuiaRemision
where GuiaId=@GuiaId
end
GO
/****** Object:  StoredProcedure [dbo].[eliminarletra]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminarletra] @LetraId numeric(38)
as
begin
delete from DocumentoCanje
where LetraId=@LetraId
begin
delete from DetalleLetra
where LetraId=@LetraId
begin
delete from Letra
where LetraId=@LetraId
end
end
end
GO
/****** Object:  StoredProcedure [dbo].[eliminarliquida]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminarliquida]
@LiquidacionId numeric(38),
@CompraId numeric(18,2),
@Acuenta decimal(18,2),
@Concepto varchar(40)
as
begin
if(@Concepto='LETRA')
begin
update DetalleLetra
set DetalleSaldo=DetalleSaldo+@Acuenta,DetalleEstado='PENDIENTE DE PAGO'
where DetalleId=@CompraId
end
else
begin
update Compras
set CompraSaldo=CompraSaldo+@Acuenta,CompraEstado='PENDIENTE DE PAGO'
where CompraId=@CompraId
end
end
begin
delete from DetalleLiquida
where LiquidacionId=@LiquidacionId
end
begin
delete from Liquidacion
where LiquidacionId=@LiquidacionId
end
GO
/****** Object:  StoredProcedure [dbo].[eliminarNotaPedido]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminarNotaPedido] 
@NotaId numeric(38)
as
begin
delete from DetallePedido
where NotaId=@NotaId
end
begin
delete from NotaPedido
where NotaId=@NotaId
end
GO
/****** Object:  StoredProcedure [dbo].[eliminarRenta]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[eliminarRenta] 
@Data varchar(max)
as
begin
Declare @RentaId numeric(38),
@Cantidad int
Set @Data = LTRIM(RTrim(@Data))
Set @RentaId=convert(numeric(38),@Data)
delete from RentaMensual
where RentaId=@RentaId
set @Cantidad=(select COUNT(r.RentaId) from RentaMensual r)
if @Cantidad<=0
begin
select 'true'
end
else
begin
(select STUFF((select '¬'+convert(varchar,r.RentaId)+'|'+convert(varchar,r.CompaniaId)+'|'+convert(varchar,r.RentaANNO)+'|'+
convert(varchar,r.RentaMes)+'|'+dbo.MesNombre(r.RentaMes)+' '+convert(varchar,r.RentaANNO)+'|'+
CONVERT(VarChar(50), cast((r.IGV) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.Renta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.SaldoIGV) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.SaldoRenta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.InteresIgv) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.InteresRenta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.TributoIgv) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.TributoRenta) as money ), 1)+'|'+
CONVERT(char(1),r.FormaPago)+'|'+convert(varchar,r.FechaCancelacion,103)+'|'+r.EntidadBancaria+'|'+r.NroOperacion+'|'+
CONVERT(VarChar(50), cast((r.PagoTotal) as money ), 1)
from RentaMensual r
where year(r.FechaCancelacion)=year(getdate())
order by r.RentaId desc
for xml path('')),1,1,''))
end
end
GO
/****** Object:  StoredProcedure [dbo].[eliminartemporales]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminartemporales] @usuarioId int
as
begin
delete from temporalLetra
where UsuarioId=@usuarioId
begin
delete from TemporalCanje
where UsuarioId=@usuarioId
end
end
GO
/****** Object:  StoredProcedure [dbo].[eliminarUM]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[eliminarUM]
@Data varchar(max)
as
begin
    Set @Data = LTRIM(RTrim(@Data))
	Declare @pos1 int,@pos2 int
	declare @IdUm int,@IdProducto numeric(20)
	declare @contador int
Set @pos1 = CharIndex('|',@Data,0)
Set @IdUm =convert(int,SUBSTRING(@Data,1,@pos1-1))
Set @pos2 =Len(@Data)+1
Set @IdProducto=convert(numeric,SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))
	delete from UnidadMedida
	where IdUm=@IdUm
set @contador=(select COUNT(*) from UnidadMedida where IdProducto=@IdProducto)	
if 	@contador<=0
begin
	select 'true'
end
else
begin
	(select STUFF ((select '¬'+convert(varchar,m.IdUm)+'|'+CONVERT(varchar,m.IdProducto)+'|'+m.UMDescripcion+'|'+
	CONVERT(VarChar(50), cast(m.ValorUM as money ),2)+'|'+CONVERT(VarChar(50),cast(m.PrecioVenta as money ), 1)+'|'+CONVERT(VarChar(50), cast(m.PrecioVentaB as money ), 1)+'|'+
	CONVERT(varchar(50),m.PrecioCosto)
	from UnidadMedida m
	where m.IdProducto=@IdProducto
	order by m.ValorUM asc
	for xml path('')),1,1,''))
end
end
GO
/****** Object:  StoredProcedure [dbo].[eliminaTipoCambio]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[eliminaTipoCambio]
@Data varchar(max)
as
begin
    Set @Data = LTRIM(RTrim(@Data))
	declare @IdTipo numeric(38)
	declare @contador int
	set @IdTipo=convert(numeric(38),@Data)
	delete from TipoCambio where IdTipo=@IdTipo
    set @contador=(select COUNT(t.IdTipo)
    from TipoCambio t 
    where MONTH(t.TipoFecha)=MONTH(GETDATE()) and YEAR(t.TipoFecha)=YEAR(GETDATE()))
if @contador<=0
begin
	select 'true'
end
else
begin
    select isnull((select STUFF((select '¬'+ convert(varchar,t.IdTipo),+'|'+
	(Convert(char(10),t.TipoFecha,103))+'|'+convert(varchar,t.TipoCompra)+'|'+
	convert(varchar,t.TipoVenta)+'|'+
	convert(varchar,t.TipoEmpresa) 
	from TipoCambio t 
	where MONTH(t.TipoFecha)=MONTH(GETDATE()) and YEAR(t.TipoFecha)=YEAR(GETDATE()) 
	order by t.TipoFecha desc
	for xml path('')),1,1,'')),'~')	
end
end
GO
/****** Object:  StoredProcedure [dbo].[equivalenteProducto]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[equivalenteProducto]
as
begin
select 'IdPro|Descripcion|UM|Valor|UB|PrecioVenta|PrecioVentaB|PrecioCosto¬100|450|100|100|100|100|100|100¬String|String|String|Decimal|String|Decimal|Decimal|Decimal¬'+
isnull((select STUFF ((select '¬'+convert(varchar,p.IdProducto)+'|'+
p.ProductoNombre+'|'+u.UMDescripcion+'|'+
convert(varchar,u.ValorUM)+'|'+p.ProductoUM+'|'+
convert(varchar,u.PrecioVenta)+'|'+
convert(varchar,u.PrecioVentaB)+'|'+
convert(varchar,u.PrecioCosto)
from UnidadMedida u
inner join Producto p
on p.IdProducto=u.IdProducto
order by p.ProductoNombre asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[fechaDetaCaja]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[fechaDetaCaja] 
@Id numeric(38),
@fechainicio date,
@fechafin date
as
begin
select
'DetalleId|CajaId|Fecha|NroNota|Movimiento|Referencia|Concepto|Moneda|TipoCambio|Efectivo|Monto|Vuelto|DetalleEfectivo|Entrega¬100|100|145|85|100|100|100|80|100|95|95|95|100|118¬String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select stuff((select '¬'+
convert(varchar,d.DetalleId)+'|'+convert(varchar,d.CajaId)+'|'+
(IsNull(convert(varchar,d.DetalleFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,d.DetalleFecha,114),1,8),''))+'|'+
convert(varchar,d.NotaId)+'|'+d.DetalleMovimiento+'|'+d.DetalleReferencia+'|'+d.DetalleConcepto+'|'+d.DetalleMoneda+'|'+convert(varchar,d.DetalleTipoCambio)+'|'+
CONVERT(VarChar(50), cast(d.DetalleEfectivo as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DetalleMonto as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DetalleVuelto as money ), 1)+'|'+
convert(varchar,d.DetalleEfectivo)+'|'+ISNULL(n.NotaEntrega,'INMEDIATA')
from CajaDetalle d
left join NotaPedido n
on n.NotaId=d.NotaId
where d.CajaId=@Id and ((Convert(char(10),d.DetalleFecha,103) BETWEEN @fechainicio AND @fechafin))
order by d.DetalleFecha desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[ingresarCompra]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ingresarCompra]
@CompaniaId int,
@CompraCorrelativo varchar(80),
@ProveedorId numeric(38),
@CompraEmision date,
@CompraComputo date,
@TipoCodigo char(20),
@CompraSerie varchar(60),
@CompraNumero varchar(80),
@CompraCondicion varchar(60),
@CompraMoneda varchar(60),
@CompraTipoCambio decimal(18,3),
@CompraDias int,
@CompraFechaPago date,
@CompraUsuario varchar(80),
@CompraTipoIgv varchar(60),
@CompraValorVenta decimal(18,2),
@CompraDescuento decimal(18,2),
@CompraSubtotal decimal(18,2),
@CompraIgv decimal(18,2),
@CompraTotal decimal(18,2),
@CompraEstado varchar(60),
@CompraAsociado varchar(60),
@compraSaldo decimal(18,2),
@CompraOBS varchar(max),
@CompraTipoSunat decimal(18,3),
@CompraConcepto varchar(60),
@CompraPercepcion decimal(18,2)
as
begin
insert into Compras values(@CompaniaId,@CompraCorrelativo,@ProveedorId,GETDATE(),
@CompraEmision,@CompraComputo,@TipoCodigo,@CompraSerie,@CompraNumero,@CompraCondicion,
@CompraMoneda,@CompraTipoCambio,@CompraDias,@CompraFechaPago,@CompraUsuario,@CompraTipoIgv,
@CompraValorVenta,@CompraDescuento,@CompraSubtotal,@CompraIgv,@CompraTotal,@CompraEstado,
@CompraAsociado,@compraSaldo,@CompraOBS,@CompraTipoSunat,@CompraConcepto,@CompraPercepcion)
select @@identity
end
GO
/****** Object:  StoredProcedure [dbo].[ingresarDetaCaja]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ingresarDetaCaja]
@CajaId numeric,
@DetalleFecha datetime,
@NotaId numeric(38),
@DetalleMovimiento varchar(80),
@DetalleReferencia varchar(80),
@DetalleConcepto varchar(250),
@DetalleMoneda varchar(40),
@DetalleTipoCambio decimal(18,2),
@DetalleMonto decimal(18,2),
@DetalleEfectivo decimal(18,2),
@DetalleVuelto decimal(18,2),
@BloqueId numeric(38)=0,
@Avisa char(1)='S'
as
begin
declare @saldoA decimal(18,2)
insert into CajaDetalle values(
@CajaId,@DetalleFecha,@NotaId,@DetalleMovimiento,
@DetalleReferencia,@DetalleConcepto,@DetalleMoneda,
@DetalleTipoCambio,@DetalleMonto,@DetalleEfectivo,@DetalleVuelto
)
END
BEGIN
update NotaPedido 
set NotaSaldo=NotaSaldo - @DetalleMonto,NotaAcuenta=NotaAcuenta+@DetalleMonto
where NotaId=@NotaId
set @saldoA=(select NotaSaldo from NotaPedido where NotaId=@NotaId)
if @saldoA<=0
begin
update NotaPedido 
set NotaEstado='CANCELADO',NotaFecha=@DetalleFecha
where NotaId=@NotaId
end
else
begin
update NotaPedido 
set NotaEstado='ACUENTA',NotaFecha=@DetalleFecha
where NotaId=@NotaId
end
begin
if @Avisa='B'
begin
insert into DetalleBloque values(@BloqueId,@NotaId)
end
end
END
GO
/****** Object:  StoredProcedure [dbo].[ingresarDetaCajaB]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ingresarDetaCajaB]
@Data varchar(max)
as
begin
Declare @p1 int,@p2 int,
		@p3 int,@p4 int,
		@p5 int,@p6 int,
		@p7 int,@p8 int,
		@p9 int,@p10 int
Declare @CajaId numeric(38),@NotaId numeric(38),
		@Movimiento varchar(80),@Referencia varchar(80),
		@Concepto varchar(250),@Moneda varchar(40),
		@TipoCambio decimal(18,3),@Monto decimal(18,2),
		@Efectivo decimal(18,2),@Vuelto decimal(18,2)
Set @Data = LTRIM(RTrim(@Data))
Set @p1 = CharIndex('|',@Data,0)
Set @p2 = CharIndex('|',@Data,@p1+1)
Set @p3 = CharIndex('|',@Data,@p2+1)
Set @p4 = CharIndex('|',@Data,@p3+1)
Set @p5 = CharIndex('|',@Data,@p4+1)
Set @p6 =CharIndex('|',@Data,@p5+1)
Set @p7 = CharIndex('|',@Data,@p6+1)
Set @p8 = CharIndex('|',@Data,@p7+1)
Set @p9= CharIndex('|',@Data,@p8+1)
Set @p10 = Len(@Data)+1
Set @CajaId =convert(numeric(38),SUBSTRING(@Data,1,@p1-1))
Set @NotaId=convert(numeric(38),SUBSTRING(@Data,@p1+1,@p2-@p1-1))
Set @Movimiento=SUBSTRING(@Data,@p2+1,@p3-@p2-1)
Set @Referencia=SUBSTRING(@Data,@p3+1,@p4-@p3-1)
Set @Concepto=SUBSTRING(@Data,@p4+1,@p5-@p4-1)
Set @Moneda=SUBSTRING(@Data,@p5+1,@p6-@p5-1)
Set @TipoCambio=convert(decimal(18,3),SUBSTRING(@Data,@p6+1,@p7-@p6-1))
Set @Monto=convert(decimal(18,2),SUBSTRING(@Data,@p7+1,@p8-@p7-1))
Set @Efectivo=convert(decimal(18,2),SUBSTRING(@Data,@p8+1,@p9-@p8-1))
Set @Vuelto=convert(decimal(18,2),SUBSTRING(@Data,@p9+1,@p10-@p9-1))
begin
insert into CajaDetalle values(@CajaId,GETDATE(),@NotaId,@Movimiento,@Referencia,
@Concepto,@Moneda,@TipoCambio,@Monto,@Efectivo,@Vuelto)
	select isnull((select stuff((select '¬'+
	convert(varchar,d.DetalleId)+'|'+convert(varchar,d.CajaId)+'|'+
	(IsNull(convert(varchar,d.DetalleFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,d.DetalleFecha,114),1,8),''))+'|'+
	convert(varchar,d.NotaId)+'|'+d.DetalleMovimiento+'|'+d.DetalleReferencia+'|'+d.DetalleConcepto+'|'+d.DetalleMoneda+'|'+convert(varchar,d.DetalleTipoCambio)+'|'+
	CONVERT(VarChar(50), cast(d.DetalleEfectivo as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(d.DetalleMonto as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(d.DetalleVuelto as money ), 1)+'|'+
	convert(varchar,d.DetalleEfectivo)+'|'+ISNULL(n.NotaEntrega,'INMEDIATA')
	from CajaDetalle d
	left join NotaPedido n
	on n.NotaId=d.NotaId
	where d.CajaId=@CajaId
	order by d.DetalleId desc
	for xml path('')),1,1,'')),'~')+'['+ 
isnull((select STUFF((select '¬'+p.ProductoCodigo+'|'+
d.DetalleDescripcion+'|'+
CONVERT(VarChar(50), cast(SUM(d.DetalleCantidad) as money ), 1)+'|'+d.DetalleUm+'|'+
CONVERT(VarChar(50), cast(SUM(d.DetalleImporte) as money ), 1)
from NotaPedido n
inner join DetallePedido d
on d.NotaId=n.NotaId
inner join Producto p
on p.IdProducto=d.IdProducto
where n.NotaEstado='CANCELADO' and CajaId=@CajaId
group by p.ProductoCodigo,d.DetalleDescripcion,d.DetalleUm
order by p.ProductoCodigo asc
for xml path('')),1,1,'')),'~')
end
end
GO
/****** Object:  StoredProcedure [dbo].[ingresarPersonal]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ingresarPersonal]
@PersonalNombres varchar(140),
@PersonalApellidos varchar(140),
@AreaId numeric(20),
@PersonalCodigo varchar (80),
@PersonalNacimiento date,
@PersonalIngreso varchar(20),
@PersonalDNI varchar(20),
@PersonalDireccion varchar(140),
@PersonalTelefono varchar(40),
@PersonalTelefonoAsi varchar(40),
@PersonalEmail varchar(100),
@PersonalSueldo decimal(18,2),
@PersonalEstado varchar(60),
@PersonalBajaFecha varchar(60),
@PersonalRuc varchar(20),
@PersonalImagen varchar(max),
@CompaniaId int,
@HoraIngreso time
as
begin
insert into Personal values
(@PersonalNombres,@PersonalApellidos,@AreaId,@PersonalCodigo,
@PersonalNacimiento,@PersonalIngreso,@PersonalDNI,@PersonalDireccion,
@PersonalTelefono,@PersonalTelefonoAsi,@PersonalEmail,
@PersonalSueldo,@PersonalEstado,@PersonalBajaFecha,@PersonalRuc,
@PersonalImagen,@CompaniaId,'',@HoraIngreso)
end
GO
/****** Object:  StoredProcedure [dbo].[ingresarProducto]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ingresarProducto]
 @IdSubLinea numeric(20),
 @ProductoCodigo varchar(300),
 @ProductoNombre varchar(300),
 @ProductoUM varchar(60),
 @ProductoCosto decimal(18,4),
 @ProductoVenta decimal(18,2),
 @ProductoVentaB decimal(18,2),
 @ProductoCantidad decimal(18,2),
 @ProductoEstado varchar(60),
 @ProductoUsuario varchar(60),
 @ProductoImagen varchar(max),
 @ValorCritico decimal(18,2)
 as
 begin
 insert into Producto values(
 @IdSubLinea,@ProductoCodigo,@ProductoNombre,
 @ProductoUM,@ProductoCosto,@ProductoVenta,
 @ProductoVentaB,@ProductoCantidad,'',@ProductoEstado,
 @ProductoUsuario,GETDATE(),@ProductoImagen,@ValorCritico)
 select @@identity
 begin
 insert into Kardex values(@@identity,GETDATE(),'Nuevo Registro','Nuevo Registro',0,
 @ProductoCantidad,0,@ProductoCosto,@ProductoCantidad,'INGRESO',@ProductoUsuario)
 end
 end
GO
/****** Object:  StoredProcedure [dbo].[ingresarProveedor]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ingresarProveedor]
@Data varchar(max)
as
begin
Declare @p1 int,@p2 int,
		@p3 int,@p4 int,
		@p5 int,@p6 int,
		@p7 int,@p8 int,
		@p9 int	
Declare @ProveedorId numeric(38),
        @Razon varchar(250),
		@Ruc varchar(20),
		@Contacto varchar(140),
		@Celular varchar(140),
		@Telefono varchar(140),
		@Correo varchar(140),
		@Direccion varchar(140),
		@Estado varchar(40)
Set @Data = LTRIM(RTrim(@Data))
Set @p1 = CharIndex('|',@Data,0)
Set @p2 = CharIndex('|',@Data,@p1+1)
Set @p3 = CharIndex('|',@Data,@p2+1)
Set @p4 = CharIndex('|',@Data,@p3+1)
Set @p5 = CharIndex('|',@Data,@p4+1)
Set @p6 = CharIndex('|',@Data,@p5+1)
Set @p7 = CharIndex('|',@Data,@p6+1)
Set @p8 = CharIndex('|',@Data,@p7+1)
Set @p9 =Len(@Data)+1
set @ProveedorId=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))
set @Razon=SUBSTRING(@Data,@p1+1,@p2-@p1-1)
set @Ruc=SUBSTRING(@Data,@p2+1,@p3-@p2-1)
set @Contacto=SUBSTRING(@Data,@p3+1,@p4-@p3-1)
set @Celular=SUBSTRING(@Data,@p4+1,@p5-@p4-1)
set @Telefono=SUBSTRING(@Data,@p5+1,@p6-@p5-1)
set @Correo=SUBSTRING(@Data,@p6+1,@p7-@p6-1)
set @Direccion=SUBSTRING(@Data,@p7+1,@p8-@p7-1)
set @Estado=SUBSTRING(@Data,@p8+1,@p9-@p8-1)
if @ProveedorId=0
begin
insert into Proveedor values(@Razon,@Ruc,@Contacto,@Celular,@Telefono,@Correo,@Direccion,@Estado)
end
else
begin
update Proveedor
set ProveedorRazon=@Razon,ProveedorRuc=@Ruc,ProveedorContacto=@Contacto,
ProveedorCelular=@Celular,ProveedorTelefono=@Telefono,ProveedorCorreo=@Correo,
ProveedorDireccion=@Direccion,ProveedorEstado=@Estado
where ProveedorId=@ProveedorId
end
	select isnull((select stuff((SELECT '¬'+ CONVERT(varchar,p.ProveedorId)+'|'+p.ProveedorRazon+'|'+p.ProveedorRuc+'|'+
	p.ProveedorContacto+'|'+p.ProveedorCelular+'|'+p.ProveedorTelefono+'|'+p.ProveedorCorreo+'|'+
	p.ProveedorDireccion+'|'+p.ProveedorEstado
	from Proveedor p
	order by p.ProveedorId desc
	for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[ingresarUsuario]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ingresarUsuario]
@PersonalId numeric(20),
@UsuarioAlias varchar(60),
@UsuarioClave varchar(40),
@UsuarioFechaReg datetime,
@UsuarioEstado varchar(40)
as
begin
insert into Usuarios values(@PersonalId,@UsuarioAlias,
dbo.encriptar(@UsuarioClave),@UsuarioFechaReg,@UsuarioEstado,
'',0,0,0,0)
end
GO
/****** Object:  StoredProcedure [dbo].[insertaClienteLD]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertaClienteLD]
@Columna varchar(max) 
 as
 begin
 declare @p0 int, 
     @p1 int,
	 @p2 int,
	 @p3 int,
	 @p4 int,
	 @p5 int,
	 @p6 int,
	 @p7 int,
	 @p8 int,
	 @p9 int,
	 @p10 int
     declare @ClienteId numeric(20), 
     @ClienteRazon varchar(140),
	 @ClienteRuc varchar(40),
	 @ClienteDni varchar(40),
	 @ClienteDireccion varchar(max),
	 @ClienteMovil varchar(80),
	 @ClienteTelefono varchar(80),
	 @ClienteCorreo varchar(80),
	 @Usuario varchar(80),
	 @ClienteEstado varchar(40),
	 @ClienteDespacho varchar(max)
	Set @Columna= LTRIM(RTrim(@Columna))
	set @p0 = CharIndex('|',@Columna,0)
	Set @p1 = CharIndex('|',@Columna,@p0+1)
	Set @p2 = CharIndex('|',@Columna,@p1+1)
	Set @p3 = CharIndex('|',@Columna,@p2+1)
	Set @p4 = CharIndex('|',@Columna,@p3+1)
	Set @p5 = CharIndex('|',@Columna,@p4+1)
	Set @p6 = CharIndex('|',@Columna,@p5+1)
	Set @p7 = CharIndex('|',@Columna,@p6+1)
	Set @p8= CharIndex('|',@Columna,@p7+1)
	Set @p9 = CharIndex('|',@Columna,@p8+1)
	Set @p10 = Len(@Columna)+1
	Set @ClienteId=Convert(numeric(20),SUBSTRING(@Columna,1,@p0-1))
	Set @ClienteRazon=SUBSTRING(@Columna,@p0+1,@p1-(@p0+1))
	Set @ClienteRuc=SUBSTRING(@Columna,@p1+1,@p2-(@p1+1))
	Set @ClienteDni=SUBSTRING(@Columna,@p2+1,@p3-(@p2+1))
	Set @ClienteDireccion=SUBSTRING(@Columna,@p3+1,@p4-(@p3+1))
	Set @ClienteMovil=SUBSTRING(@Columna,@p4+1,@p5-(@p4+1))
	Set @ClienteTelefono=SUBSTRING(@Columna,@p5+1,@p6-(@p5+1))
	Set @ClienteCorreo=SUBSTRING(@Columna,@p6+1,@p7-(@p6+1))
	Set @ClienteEstado=SUBSTRING(@Columna,@p7+1,@p8-(@p7+1))
	Set @ClienteDespacho=SUBSTRING(@Columna,@p8+1,@p9-@p8-1)
    Set @Usuario=SUBSTRING(@Columna,@p9+1,@p10-(@p9+1))
if(@ClienteId=0)
begin
	insert into Cliente values(@ClienteRazon,@ClienteRuc,@ClienteDni,@ClienteDireccion,@ClienteMovil,@ClienteTelefono,@ClienteCorreo,@ClienteEstado,@ClienteDespacho,@Usuario,GETDATE())
end
else
begin
	update Cliente
	set ClienteRazon=@ClienteRazon,ClienteRuc=@ClienteRuc,ClienteDni=@ClienteDni,ClienteDireccion=@ClienteDireccion,
	ClienteMovil=@ClienteMovil,ClienteTelefono=@ClienteTelefono,ClienteCorreo=@ClienteCorreo,ClienteUsuario=@Usuario,
	clienteEstado=@ClienteEstado,ClienteDespacho=@ClienteDespacho,clienteFecha=GETDATE()
	where ClienteId=@ClienteId
end
Select 'true';
End
GO
/****** Object:  StoredProcedure [dbo].[insertaDetaLiquiVenta]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertaDetaLiquiVenta]
@LiquidacionId numeric(38),
@DocuId numeric(38),
@NotaId numeric(38),
@SaldoDocu decimal(18,2),
@EfectivoSoles decimal(18, 2),
@EfectivoDolar decimal(18, 2),
@DepositoSoles decimal(18, 2),
@DepositoDolar decimal(18, 2),
@TipoCambio decimal(18, 3),
@EntidadBanco varchar(80),
@NroOperacion varchar(80),
@AcuentaGeneral decimal(18, 2),
@SaldoActual decimal(18, 2),
@FechaPago varchar(60),
@DocuEstado varchar(60)
as
insert into DetaLiquidaVenta values(
@LiquidacionId,@DocuId,@NotaId,@SaldoDocu,@EfectivoSoles,
@EfectivoDolar,@DepositoSoles,@DepositoDolar,
@TipoCambio,@EntidadBanco,@NroOperacion,
@AcuentaGeneral,@SaldoActual,@FechaPago
)
update NotaPedido
set NotaSaldo=NotaSaldo-@AcuentaGeneral,NotaEstado=@DocuEstado
where NotaId=@NotaId
GO
/****** Object:  StoredProcedure [dbo].[insertaGuiaCanje]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertaGuiaCanje]
@CompraId numeric(38),
@CompaniaId int,
@CanjeFecha date,
@CanjeRegistro datetime,
@CanjeSerie varchar(80),
@CanjeNumero varchar(80),
@CanjeEmision date,
@CanjeComputo date,
@CanjeCorrelativo varchar(80),
@CanjeTipo varchar(80),
@CanjeOBS varchar(max),
@TCSunat decimal(18,3),
@GCompania int,
@GSerie varchar(80),
@GNumero varchar(80),
@GEmision date,
@GCanjeComputo date,
@GCanjeCorrelativo varchar(80),
@GCanjeTipo varchar(80),
@GCanjeOBS varchar(max),
@GTCSunat decimal(18,3),
@CanjeUsuario varchar(60),
@Subtotal decimal(18,2),
@Igv decimal(18,2),
@Total decimal(18,2)
as
begin
insert into GuiaCanje values(@CompraId,@CompaniaId,@CanjeFecha,@CanjeRegistro,@CanjeSerie,@CanjeNumero,
@CanjeEmision,@CanjeComputo,@CanjeCorrelativo,@CanjeTipo,@CanjeOBS,@TCSunat,@GCompania,@GSerie,@GNumero,@GEmision,
@GCanjeComputo,@GCanjeCorrelativo,@GCanjeTipo,@GCanjeOBS,@GTCSunat,@CanjeUsuario)
begin
update Compras
set CompaniaId=@CompaniaId,CompraTipoSunat=@TCSunat,CompraSerie=@CanjeSerie,CompraNumero=@CanjeNumero,CompraEmision=@CanjeEmision,
CompraComputo=@CanjeComputo,CompraCorrelativo=@CanjeCorrelativo,CompraTipoIgv=@CanjeTipo,CompraOBS=@CanjeOBS,TipoCodigo='01',
CompraSubtotal=@Subtotal,CompraIgv=@Igv,CompraTotal=@Total
where CompraId=@CompraId
end
end
GO
/****** Object:  StoredProcedure [dbo].[insertaLiquidaVenta]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertaLiquidaVenta]
@LiquidacionNumero varchar(80),
@LiquidacionRegistro datetime,
@LiquidacionFecha date,
@LiquidacionDescripcion varchar(250),
@LiquidacionCambio decimal(18,3),
@LiquidaEfectivoSol decimal(18,2),
@LiquidaDepositoSol decimal(18,2),
@LiquidaTotalSol decimal(18,2),
@LiquidaEfectivoDol decimal(18,2),
@LiquidaDepositoDol decimal(18,2),
@LiquidaTotalDol decimal(18,2),
@LiquidaUsuario varchar(60)
as
begin
insert into LiquidacionVenta values(@LiquidacionNumero,
@LiquidacionRegistro,@LiquidacionFecha,@LiquidacionDescripcion,
@LiquidacionCambio,@LiquidaEfectivoSol,@LiquidaDepositoSol,
@LiquidaTotalSol,@LiquidaEfectivoDol,@LiquidaDepositoDol,
@LiquidaTotalDol,@LiquidaUsuario)
select @@identity
end
GO
/****** Object:  StoredProcedure [dbo].[insertarAlmacen]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[insertarAlmacen]
@Data varchar(max)
as
begin
Declare @pos1 int
Declare @pos2 int
Declare @pos3 int
Declare @pos4 int
Declare @pos5 int
Declare @pos6 int
Declare @pos7 int
Declare @AlmacenId numeric(20)
Declare @AlmacenNombre varchar(80)
Declare @AlmacenDepartamento varchar(80)
Declare @AlmacenProvincia varchar(80)
Declare @AlmacenDistrito varchar(80)
Declare @AlmacenDireccion varchar(300)
Declare @AlmacenEstado varchar(20)
Declare @AlmacenBD varchar(80)
Set @Data = LTRIM(RTrim(@Data))
Set @pos1 = CharIndex('|',@Data,0)
Set @AlmacenId =convert(numeric,SUBSTRING(@Data,1,@pos1-1))
Set @pos2 = CharIndex('|',@Data,@pos1+1)
Set @AlmacenNombre = SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1)
Set @pos3 = CharIndex('|',@Data,@pos2+1)
Set @AlmacenDepartamento=SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1)
Set @pos4 = CharIndex('|',@Data,@pos3+1)
Set @AlmacenProvincia=SUBSTRING(@Data,@pos3+1,@pos4-@pos3-1)
Set @pos5 = CharIndex('|',@Data,@pos4+1)
Set @AlmacenDistrito=SUBSTRING(@Data,@pos4+1,@pos5-@pos4-1)
Set @pos6 =CharIndex('|',@Data,@pos5+1)
Set @AlmacenDireccion=SUBSTRING(@Data,@pos5+1,@pos6-@pos5-1)
Set @pos7 = Len(@Data)+1
Set @AlmacenEstado=SUBSTRING(@Data,@pos6+1,@pos7-@pos6-1)
set @AlmacenBD=(select top 1 a.AlmacenNombre from Almacen a where AlmacenNombre=@AlmacenNombre)
if @AlmacenId=0
begin
if(@AlmacenBD=@AlmacenNombre)
begin
select 'existe'
end
else
begin
insert into Almacen values(@AlmacenNombre,@AlmacenDepartamento,@AlmacenProvincia,@AlmacenDistrito,@AlmacenDireccion,@AlmacenEstado)
(select STUFF((select '¬'+ convert(varchar,a.AlmacenId)+'|'+a.AlmacenNombre+'|'+a.AlmacenDepartamento+'|'+
a.AlmacenProvincia+'|'+a.AlmacenDistrito+'|'+a.AlmacenDireccion+'|'+a.AlmacenEstado
from Almacen a
order by AlmacenId desc
for xml path('')),1,1,''))
end
end
else
begin
update Almacen
set AlmacenNombre=@AlmacenNombre,AlmacenDepartamento=@AlmacenDepartamento,AlmacenProvincia=@AlmacenProvincia,AlmacenDistrito=@AlmacenDistrito,AlmacenDireccion=@AlmacenDireccion,AlmacenEstado=@AlmacenEstado
where AlmacenId=@AlmacenId
(select STUFF((select '¬'+ convert(varchar,a.AlmacenId)+'|'+a.AlmacenNombre+'|'+a.AlmacenDepartamento+'|'+
a.AlmacenProvincia+'|'+a.AlmacenDistrito+'|'+a.AlmacenDireccion+'|'+a.AlmacenEstado
from Almacen a
order by AlmacenId desc
for xml path('')),1,1,''))
end
end
GO
/****** Object:  StoredProcedure [dbo].[insertarCajaPri]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[insertarCajaPri]
@Data varchar(max)
as
begin
Declare @p1 int,@p2 int,
		@p3 int,@p4 int,
		@p5 int,@p6 int,
		@p7 int
declare @CajaConcepto varchar(80),
		@CajaId numeric(38),
		@CajaDescripcion varchar(250),
		@CajaMonto decimal(18,2),
		@CajaUsuario varchar(20),
		@Aviso char(1),
		@RutaImagen varchar(max)
Set @Data = LTRIM(RTrim(@Data))
		Set @p1 = CharIndex('|',@Data,0)
		Set @p2 = CharIndex('|',@Data,@p1+1)
		Set @p3 = CharIndex('|',@Data,@p2+1)
		Set @p4 = CharIndex('|',@Data,@p3+1)
		Set @p5= CharIndex('|',@Data,@p4+1)
		Set @p6= CharIndex('|',@Data,@p5+1)
		Set @p7= Len(@Data)+1
		Set @CajaConcepto=SUBSTRING(@Data,1,@p1-1)
		Set @CajaId=convert(numeric(38),SUBSTRING(@Data,@p1+1,@p2-@p1-1))
		Set @CajaDescripcion=SUBSTRING(@Data,@p2+1,@p3-@p2-1)
		Set @CajaMonto=convert(decimal(18,2),SUBSTRING(@Data,@p3+1,@p4-@p3-1))
		Set @CajaUsuario=SUBSTRING(@Data,@p4+1,@p5-@p4-1)
		Set @Aviso=SUBSTRING(@Data,@p5+1,@p6-@p5-1)
		Set @RutaImagen=SUBSTRING(@Data,@p6+1,@p7-@p6-1)		
begin
IF EXISTS(select CajaId from CajaPincipal where CajaId=@CajaId and CajaId<>0)
begin
	update CajaPincipal
	set CajaConcepto=@CajaConcepto,CajaFecha=GETDATE(),
	CajaDescripcion=@CajaDescripcion,CajaMonto=@CajaMonto,
	CajaUsuario=@CajaUsuario
	where CajaId=@CajaId
end
else
begin
	insert into CajaPincipal values(@CajaConcepto,GETDATE(),
	@CajaId,@CajaDescripcion,@CajaMonto,@CajaUsuario,0,@RutaImagen)
end
if @Aviso='1'
begin
select isnull((select STUFF((select '¬'+ convert(varchar,c.IdCaja)+'|'+c.CajaConcepto+'|'+convert(varchar,c.CajaId)+'|'+
Convert(char(10),c.CajaFecha,103)+' '+Convert(char(8),c.CajaFecha,114) 
+'|'+c.CajaDescripcion+'|'+CONVERT(VarChar(50),cast(c.CajaMonto as money), 1)+'|'+
c.CajaUsuario+'|'+c.RutaImagen  
from CajaPincipal c 
where c.CajaConcepto='INGRESO' and c.IdGeneral=0
order by c.IdCaja desc
for xml path('')),1,1,'')),'~')+'['+
isnull((select STUFF((select '¬'+ convert(varchar,c.IdCaja)+'|'+c.CajaConcepto+'|'+convert(varchar,c.CajaId)+'|'+
Convert(char(10),c.CajaFecha,103)+' '+Convert(char(8),c.CajaFecha,114) 
+'|'+c.CajaDescripcion+'|'+CONVERT(VarChar(50),cast(c.CajaMonto as money), 1)+'|'+
c.CajaUsuario+'|'+c.RutaImagen  
from CajaPincipal c 
where c.CajaConcepto='SALIDA' and c.IdGeneral=0
order by c.IdCaja desc
for xml path('')),1,1,'')),'~')
end
else
begin
select 'true'
end
end
end
GO
/****** Object:  StoredProcedure [dbo].[insertarCanje]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarCanje]
@temporalCanje varchar(80),
@temporalDias int,
@temporalVencimiento varchar(20),
@temporalMonto decimal(18,2),
@usuarioId int
as
begin
insert into TemporalCanje values(@temporalCanje,
@temporalDias,@temporalVencimiento,@temporalMonto,@usuarioId)
end
GO
/****** Object:  StoredProcedure [dbo].[insertarDetaBonificacion]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[insertarDetaBonificacion]
@CompraId numeric(38),
@IdProducto numeric(20),
@DetalleCodigo varchar(80),
@Descripcion varchar(255),
@DetalleUM   varchar(60),
@DetalleCantidad decimal(18,2),
@PrecioCosto  decimal(18,4),
@DetalleImprte decimal(18,4),
@DetalleDescuento decimal(18,4),
@DetalleEstado varchar(60),
@KardexDocumento varchar(80),
@Usuario varchar(80)
as
Begin Transaction
insert into DetalleCompra values(@CompraId,@IdProducto,@DetalleCodigo,
@Descripcion,@DetalleUM,@DetalleCantidad,@PrecioCosto,@DetalleImprte,
@DetalleDescuento,@DetalleEstado,0,'',1)

declare @IniciaStock decimal(18,2),@StockFinal decimal(18,2),@Concepto varchar(40)
set @IniciaStock=(select top 1 ProductoCantidad from Producto where IdProducto=@IdProducto)
set @StockFinal=@IniciaStock+@DetalleCantidad
set @concepto='INGRESO'
insert into Kardex values(@IdProducto,GETDATE(),'Ingreso por Compra',@KardexDocumento,@IniciaStock,
@DetalleCantidad,0,@PrecioCosto,@StockFinal,@Concepto,@Usuario)
update producto 
set ProductoCantidad =ProductoCantidad + @DetalleCantidad
where IDProducto=@IdProducto
Commit Transaction;
GO
/****** Object:  StoredProcedure [dbo].[insertarDetaGuia]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarDetaGuia]
@GuiaId numeric(38),
@IdProducto numeric(20),
@DetalleCantidad decimal(18,2),
@DetalleCosto decimal(18,4),
@DetallePrecio decimal(18, 2),
@DetalleImporte decimal(18, 2),
@DetalleEstado varchar(60),
@flac int,
@IdDetalle numeric(38),
@Documento varchar(80),
@Usuario varchar(80),
@Concepto varchar(80),
@ValorUM decimal(18,4),
@UniMedida varchar(40)
as
declare @Inicial decimal(18,2),@final decimal(18,2),@cantidad decimal(18,2)
set @Inicial=(select p.ProductoCantidad from Producto p where p.IdProducto=@IdProducto)
set @cantidad=(@DetalleCantidad * @ValorUM)
if(@Concepto='INGRESO')
begin
set @final=@Inicial+@cantidad
end
else
begin
set @final=@Inicial-@cantidad
end
begin
begin
insert into DetalleGuia values(@GuiaId,@IdProducto,@DetalleCantidad,@DetalleCosto,
@DetallePrecio,@DetalleImporte,@DetalleEstado,@IdDetalle,@ValorUM,@UniMedida)
if(@flac=1)
update DetallePedido
set CantidadSaldo=CantidadSaldo-@DetalleCantidad
where DetalleId=@IdDetalle
end
begin
update producto 
set ProductoCantidad =@final
where IDProducto=@IDProducto
end
begin
if(@Concepto='INGRESO')
begin
insert into Kardex values(@IdProducto,GETDATE(),
'Ingreso por Guia',@Documento,@inicial,@Cantidad,0,@DetalleCosto,@final,'INGRESO',@Usuario)
end
else
begin
insert into Kardex values(@IdProducto,GETDATE(),
'Salida por Guia',@Documento,@inicial,0,@cantidad,@DetalleCosto,@final,'SALIDA',@Usuario)
end
end
end
GO
/****** Object:  StoredProcedure [dbo].[insertarDetaLetra]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarDetaLetra]
@LetraId  numeric(38),
@LetraCanje varchar(80),
@LetraDias int,
@LetraVencimiento date,
@DetalleSaldo decimal(18,2),
@DetalleMonto decimal(18,2),
@DetalleEstado varchar(60)
as
begin
insert into DetalleLetra values(@LetraId,@LetraCanje,
@LetraDias,@LetraVencimiento,@DetalleMonto,
@DetalleSaldo,@DetalleEstado)
end
GO
/****** Object:  StoredProcedure [dbo].[insertarDetaLiquida]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarDetaLiquida]
@LiquidacionId numeric(38),
@CompraId numeric(38),
@SaldoDocu decimal(18,2),
@EfectivoSoles decimal(18, 2),
@EfectivoDolar decimal(18, 2),
@DepositoSoles decimal(18, 2),
@DepositoDolar decimal(18, 2),
@TipoCambio decimal(18, 3),
@EntidadBanco varchar(80),
@NroOperacion varchar(80),
@AcuentaGeneral decimal(18, 2),
@SaldoActual decimal(18, 2),
@FechaPago varchar(60),
@Numero varchar(60),
@Proveedor varchar(255),
@Moneda varchar(20),
@Concepto varchar(40),
@CompraEstado varchar(60)
as
begin
insert into DetalleLiquida values(
@LiquidacionId,@CompraId,@SaldoDocu,@EfectivoSoles,@EfectivoDolar,@DepositoSoles,
@DepositoDolar,@TipoCambio,@EntidadBanco,@NroOperacion,@AcuentaGeneral,@SaldoActual,@FechaPago,@Numero,
@Proveedor,@Moneda,@Concepto
)
begin
if(@Concepto='COMPRA')
begin
update Compras
set CompraSaldo=CompraSaldo - @AcuentaGeneral,CompraEstado=@CompraEstado
where CompraId=@CompraId
end
else
begin
update DetalleLetra
set DetalleSaldo=DetalleSaldo-@AcuentaGeneral,DetalleEstado=@CompraEstado
where DetalleId=@CompraId
end
end
end
GO
/****** Object:  StoredProcedure [dbo].[insertarDetalleCompra]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarDetalleCompra]
@CompraId numeric(38),
@IdProducto numeric(20),
@DetalleCodigo varchar(80),
@Descripcion varchar(255),
@DetalleUM   varchar(60),
@DetalleCantidad decimal(18,2),
@PrecioCosto  decimal(18,4),
@DetalleImprte decimal(18,4),
@DetalleDescuento decimal(18,4),
@DetalleEstado varchar(60)
as
begin
insert into DetalleCompra values(@CompraId,@IdProducto,@DetalleCodigo,
@Descripcion,@DetalleUM,@DetalleCantidad,@PrecioCosto,@DetalleImprte,
@DetalleDescuento,@DetalleEstado,0,'',1)
end
GO
/****** Object:  StoredProcedure [dbo].[insertarDetalleNota]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarDetalleNota]
@NotaId numeric(38),
@IdProducto numeric(20),
@DetalleCantidad decimal(18,2),
@DetalleUm varchar(40),
@DetalleDescripcion varchar(140),
@DetalleCosto decimal(18,2), 
@DetallePrecio decimal(18,2),
@DetalleImporte decimal(18,2),
@DetalleEstado varchar(60),
@CantidadSaldo decimal(18,2),
@ValorUM decimal(18,4),
@DocuId numeric(38)=0
as
begin
declare @DetalleNotaId numeric(38)       
begin
insert into DetallePedido values(@NotaId,@IdProducto,@DetalleCantidad,
@DetalleUm,@DetalleDescripcion,@DetalleCosto, @DetallePrecio,
@DetalleImporte,@DetalleEstado,@CantidadSaldo,@ValorUM)
set @DetalleNotaId=(select @@IDENTITY)
end
if(@DocuId<>'0')
begin
insert into DetalleDocumento values
(@DocuId,@IdProducto,@DetalleCantidad,@DetallePrecio,@DetalleImporte,
@DetalleNotaId,@DetalleUm,@ValorUM)
end
end
GO
/****** Object:  StoredProcedure [dbo].[insertarGeneral]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[insertarGeneral]
@Data varchar(max)
as
begin
Declare @p1 int,@p2 int,
		@p3 int,@p4 int,
		@p5 int
Declare
		@IdGeneral numeric(38),
		@Usuario varchar(80),
		@Ingresos decimal(18,2),
		@Salidas decimal(18,2),
		@Total decimal(18,2),
		@Codigo numeric(38)
Set @Data = LTRIM(RTrim(@Data))
Set @p1 = CharIndex('|',@Data,0)
Set @p2 = CharIndex('|',@Data,@p1+1)
Set @p3 = CharIndex('|',@Data,@p2+1)
Set @p4 = CharIndex('|',@Data,@p3+1)
Set @p5 =Len(@Data)+1
set @IdGeneral=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))
set @Usuario=SUBSTRING(@Data,@p1+1,@p2-@p1-1)
set @Ingresos=convert(decimal(18,2),SUBSTRING(@Data,@p2+1,@p3-@p2-1))
set @Salidas=convert(decimal(18,2),SUBSTRING(@Data,@p3+1,@p4-@p3-1))
set @Total=convert(decimal(18,2),SUBSTRING(@Data,@p4+1,@p5-@p4-1))
if(@IdGeneral=0)
begin
insert into CajaGeneral values(GETDATE(),@Usuario,@Ingresos,@Salidas,@Total)
set @Codigo=(select @@IDENTITY)
update CajaPincipal
set IdGeneral=@Codigo
where IdGeneral=0
end
else
begin
update CajaGeneral
set FechaCierre=GETDATE(),Ingresos=@Ingresos,Salidas=@Salidas,Total=@Total,Usuario=@Usuario
where IdGeneral=@IdGeneral
end
begin
select isnull((select STUFF((select '¬'+ convert(varchar,c.IdCaja)+'|'+c.CajaConcepto+'|'+convert(varchar,c.CajaId)+'|'+
Convert(char(10),c.CajaFecha,103)+' '+Convert(char(8),c.CajaFecha,114) 
+'|'+c.CajaDescripcion+'|'+CONVERT(VarChar(50),cast(c.CajaMonto as money), 1)+'|'+
c.CajaUsuario+'|'+c.RutaImagen
from CajaPincipal c 
where c.CajaConcepto='INGRESO' and c.IdGeneral=0
order by c.IdCaja desc
for xml path('')),1,1,'')),'~')+'['+
isnull((select STUFF((select '¬'+ convert(varchar,c.IdCaja)+'|'+c.CajaConcepto+'|'+convert(varchar,c.CajaId)+'|'+
Convert(char(10),c.CajaFecha,103)+' '+Convert(char(8),c.CajaFecha,114) 
+'|'+c.CajaDescripcion+'|'+CONVERT(VarChar(50),cast(c.CajaMonto as money), 1)+'|'+
c.CajaUsuario+'|'+c.RutaImagen
from CajaPincipal c 
where c.CajaConcepto='SALIDA' and c.IdGeneral=0
order by c.IdCaja desc
for xml path('')),1,1,'')),'~')+'['+
isnull((select STUFF ((select '¬'+ CONVERT(varchar,c.IdGeneral)+'|'+
(IsNull(convert(varchar,c.FechaCierre,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,c.FechaCierre,114),1,8),''))+'|'+c.Usuario+'|'+
CONVERT(varchar(50),cast(c.Ingresos as money),1)+'|'+CONVERT(varchar(50),cast(c.Salidas as money),1)+'|'+
CONVERT(varchar(50),cast(c.Total as money),1)
from CajaGeneral c
order by c.IdGeneral desc
for xml path('')),1,1,'')),'~')
end
end
GO
/****** Object:  StoredProcedure [dbo].[insertarGR]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarGR]
@GuiaId numeric(38),
@NotaId numeric(38)
as
begin
begin
insert into GuiaRelacion values(@GuiaId,@NotaId)
end
begin
update GuiaRemision
set GuiaEstado='CANJEADO'
where GuiaId=@GuiaId
end
end
GO
/****** Object:  StoredProcedure [dbo].[insertarGuia]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarGuia]
@GuiaNumero varchar(60),
@GuiaMotivo varchar(80),
@GuiaRegistro datetime,
@GuiaFechaTraslado datetime,
@GuiaDestinatario varchar(250),
@GuiaRucDes varchar(60),
@GuiaAlmacen varchar(80),
@GuiaPartida varchar(max),
@GuiaLLegada varchar(max),
@GuiaTramsporte varchar(80),
@GuiaTransporteRuc varchar(20),
@GuiaChofer varchar(80),
@GuiaPlaca varchar(80),
@GuiaConstancia varchar(80),
@GuiaLicencia varchar(80),
@GuiaUsuario varchar(80),
@GuiaTotal decimal(18,2),
@GuiaConcepto varchar(40),
@ClienteId numeric(20),
@GuiaEstado varchar(60),
@GuiaTelefono varchar(80)
as
begin
insert into GuiaRemision values(@GuiaNumero,@GuiaMotivo,
@GuiaRegistro,@GuiaFechaTraslado,@GuiaDestinatario,@GuiaRucDes,@GuiaAlmacen,@GuiaPartida,
@GuiaLLegada,@GuiaTramsporte,@GuiaTransporteRuc,@GuiaChofer,@GuiaPlaca,@GuiaConstancia,
@GuiaLicencia,@GuiaUsuario,@GuiaTotal,@GuiaConcepto,@ClienteId,@GuiaEstado,@GuiaTelefono
)													
select @@identity
end
GO
/****** Object:  StoredProcedure [dbo].[insertarKardexB]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarKardexB]
	 @IdProducto numeric(20),
	 @KardexMotivo  varchar(60),
	 @KardexDocumento varchar(60),
	 @CantidadIngreso decimal(18, 2),
	 @CantidadSalida decimal(18, 2),
	 @PrecioCosto decimal(18,4),
	 @Usuario varchar(60),
	 @Aviso char(1)
	as
	begin
	declare @IniciaStock decimal(18,2),@StockFinal decimal(18,2),@Concepto varchar(40)
	set @IniciaStock=(select top 1 ProductoCantidad from Producto where IdProducto=@IdProducto)
	if @Aviso='S'
	begin
	set @StockFinal=@IniciaStock-@CantidadSalida
	set @concepto='SALIDA'
	end
	else if @Aviso='I'
	begin
	set @StockFinal=@IniciaStock+@CantidadIngreso
	set @concepto='INGRESO'
	end
	else
	begin
	set @StockFinal=@IniciaStock
	set @concepto='INGRESO'
	end
	insert into Kardex values(@IdProducto,GETDATE(),@KardexMotivo,@KardexDocumento,@IniciaStock,
	@CantidadIngreso,@CantidadSalida,@PrecioCosto,@StockFinal,@Concepto,@Usuario)
	if @Aviso='S'
	begin
	update producto 
	set  ProductoCantidad =ProductoCantidad - @CantidadSalida
	where IDProducto=@IdProducto
	end
	else if @Aviso='I'
	begin
	update producto
	set ProductoCantidad =ProductoCantidad + @CantidadIngreso
	where IDProducto=@IdProducto
	end
	end
GO
/****** Object:  StoredProcedure [dbo].[insertarLetra]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarLetra]
@ProveedorId numeric(38),
@LetraFechaReg datetime,
@LetraFechaGiro date,
@LetraMoneda varchar(40),
@LetraSaldo decimal(18,2),
@LetraTotal decimal(18,2),
@letraUsuario varchar(60),
@LetraEstado varchar(60),
@CompaniaId INT 
as
begin
insert into Letra values(@ProveedorId,@LetraFechaReg,@LetraFechaGiro,
@LetraMoneda,@LetraSaldo,@LetraTotal,@letraUsuario,@LetraEstado,@CompaniaId)
select @@identity
end
GO
/****** Object:  StoredProcedure [dbo].[insertarLiquida]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarLiquida]
@LiquidacionNumero varchar(80),
@LiquidacionRegistro datetime,
@LiquidacionFecha date,
@LiquidacionDescripcion varchar(250),
@LiquidacionCambio decimal(18,3),
@LiquidaEfectivoSol decimal(18,2),
@LiquidaDepositoSol decimal(18,2),
@LiquidaTotalSol decimal(18,2),
@LiquidaEfectivoDol decimal(18,2),
@LiquidaDepositoDol decimal(18,2),
@LiquidaTotalDol decimal(18,2),
@LiquidaUsuario varchar(60)
as
begin
insert into Liquidacion values(@LiquidacionNumero,
@LiquidacionRegistro,@LiquidacionFecha,@LiquidacionDescripcion,
@LiquidacionCambio,@LiquidaEfectivoSol,@LiquidaDepositoSol,
@LiquidaTotalSol,@LiquidaEfectivoDol,@LiquidaDepositoDol,
@LiquidaTotalDol,@LiquidaUsuario)
select @@identity
end
GO
/****** Object:  StoredProcedure [dbo].[insertarRenta]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[insertarRenta] 
@Data varchar(max)
as
declare @existe int
		Declare @pos1 int,@pos2 int,@pos3 int,@pos4 int,
		@pos5 int,@pos6 int,@pos7 int,@pos8 int,@pos9 int,
		@pos10 int,@pos11 int,@pos12 int,@pos13 int,@pos14 int,
		@pos15 int,@pos16 int,@pos17 int,@pos18 int
Declare @RentaId numeric(38),@CompaniaId int,@RentaUsuario varchar(80),
		@RentaANNO int,@RentaMes int,@IGV decimal(18,2),@Renta decimal(18,2),
		@SaldoIGV decimal(18,2),@SaldoRenta decimal(18,2),@InteresIgv decimal(18,2),
		@InteresRenta decimal(18,2),@TributoIgv decimal(18,2),@TributoRenta decimal(18,2),
		@FormaPago bit,@FechaCancelacion datetime,@EntidadBancaria varchar(80),
		@NroOperacion varchar(80),@PagoTotal decimal(18,2)
Set @Data = LTRIM(RTrim(@Data))
Set @pos1 = CharIndex('|',@Data,0)
Set @RentaId=convert(numeric(38),SUBSTRING(@Data,1,@pos1-1))
Set @pos2 = CharIndex('|',@Data,@pos1+1)
Set @CompaniaId= convert(int,SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))
Set @pos3 = CharIndex('|',@Data,@pos2+1)
Set @RentaUsuario=SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1)
Set @pos4 = CharIndex('|',@Data,@pos3+1)
Set @RentaANNO=convert(int,SUBSTRING(@Data,@pos3+1,@pos4-@pos3-1))
Set @pos5 = CharIndex('|',@Data,@pos4+1)
Set @RentaMes=convert(int,SUBSTRING(@Data,@pos4+1,@pos5-@pos4-1))
Set @pos6 =CharIndex('|',@Data,@pos5+1)
Set @IGV=convert(decimal(18,2),SUBSTRING(@Data,@pos5+1,@pos6-@pos5-1))
Set @pos7 =CharIndex('|',@Data,@pos6+1)
Set @Renta=convert(decimal(18,2),SUBSTRING(@Data,@pos6+1,@pos7-@pos6-1))
Set @pos8 =CharIndex('|',@Data,@pos7+1)
Set @SaldoIGV=convert(decimal(18,2),SUBSTRING(@Data,@pos7+1,@pos8-@pos7-1))
Set @pos9 =CharIndex('|',@Data,@pos8+1)
Set @SaldoRenta=convert(decimal(18,2),SUBSTRING(@Data,@pos8+1,@pos9-@pos8-1))
Set @pos10=CharIndex('|',@Data,@pos9+1)
Set @InteresIgv=convert(decimal(18,2),SUBSTRING(@Data,@pos9+1,@pos10-@pos9-1))
Set @pos11=CharIndex('|',@Data,@pos10+1)
Set @InteresRenta=convert(decimal(18,2),SUBSTRING(@Data,@pos10+1,@pos11-@pos10-1))
Set @pos12=CharIndex('|',@Data,@pos11+1)
Set @TributoIgv=convert(decimal(18,2),SUBSTRING(@Data,@pos11+1,@pos12-@pos11-1))
Set @pos13=CharIndex('|',@Data,@pos12+1)
Set @TributoRenta=convert(decimal(18,2),SUBSTRING(@Data,@pos12+1,@pos13-@pos12-1))
Set @pos14=CharIndex('|',@Data,@pos13+1)
Set @FormaPago=convert(bit,SUBSTRING(@Data,@pos13+1,@pos14-@pos13-1))
Set @pos15=CharIndex('|',@Data,@pos14+1)
Set @FechaCancelacion=convert(date,SUBSTRING(@Data,@pos14+1,@pos15-@pos14-1))
Set @pos16=CharIndex('|',@Data,@pos15+1)
Set @EntidadBancaria=SUBSTRING(@Data,@pos15+1,@pos16-@pos15-1)
Set @pos17=CharIndex('|',@Data,@pos16+1)
Set @NroOperacion=SUBSTRING(@Data,@pos16+1,@pos17-@pos16-1)
Set @pos18= Len(@Data)+1
Set @PagoTotal=convert(decimal(18,2),SUBSTRING(@Data,@pos17+1,@pos18-@pos17-1))
set @existe=(select count(RentaId)as Codigo from RentaMensual
             where CompaniaId=@CompaniaId and(RentaANNO=@RentaANNO and RentaMes=@RentaMes))
begin
if @RentaId=0
begin  
if @existe=0
begin
insert into RentaMensual values
(@CompaniaId,@RentaUsuario,
@RentaANNO,@RentaMes,@IGV,@Renta,@SaldoIGV,
@SaldoRenta,@InteresIgv,@InteresRenta,@TributoIgv,@TributoRenta,@FormaPago,@FechaCancelacion,
@EntidadBancaria,@NroOperacion,@PagoTotal
)
(select STUFF((select '¬'+convert(varchar,r.RentaId)+'|'+convert(varchar,r.CompaniaId)+'|'+convert(varchar,r.RentaANNO)+'|'+
convert(varchar,r.RentaMes)+'|'+dbo.MesNombre(r.RentaMes)+' '+convert(varchar,r.RentaANNO)+'|'+
CONVERT(VarChar(50), cast((r.IGV) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.Renta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.SaldoIGV) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.SaldoRenta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.InteresIgv) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.InteresRenta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.TributoIgv) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.TributoRenta) as money ), 1)+'|'+
CONVERT(char(1),r.FormaPago)+'|'+convert(varchar,r.FechaCancelacion,103)+'|'+r.EntidadBancaria+'|'+r.NroOperacion+'|'+
CONVERT(VarChar(50), cast((r.PagoTotal) as money ), 1)
from RentaMensual r
where year(r.FechaCancelacion)=year(getdate())
order by r.RentaId desc
for xml path('')),1,1,''))
end
else
begin
select 'existe'
end
end
else
begin
update RentaMensual
set IGV=@IGV,Renta=@Renta,SaldoIGV=@SaldoIGV,SaldoRenta=@SaldoRenta,InteresIgv=@InteresIgv,
InteresRenta=@InteresRenta,TributoIgv=@TributoIgv,TributoRenta=@TributoRenta,FormaPago=@FormaPago,
FechaCancelacion=@FechaCancelacion,EntidadBancaria=@EntidadBancaria,NroOperacion=@NroOperacion,PagoTotal=@PagoTotal
where RentaId=@RentaId
(select STUFF((select '¬'+convert(varchar,r.RentaId)+'|'+convert(varchar,r.CompaniaId)+'|'+convert(varchar,r.RentaANNO)+'|'+
convert(varchar,r.RentaMes)+'|'+dbo.MesNombre(r.RentaMes)+' '+convert(varchar,r.RentaANNO)+'|'+
CONVERT(VarChar(50), cast((r.IGV) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.Renta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.SaldoIGV) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.SaldoRenta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.InteresIgv) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.InteresRenta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.TributoIgv) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.TributoRenta) as money ), 1)+'|'+
CONVERT(char(1),r.FormaPago)+'|'+convert(varchar,r.FechaCancelacion,103)+'|'+r.EntidadBancaria+'|'+r.NroOperacion+'|'+
CONVERT(VarChar(50), cast((r.PagoTotal) as money ), 1)
from RentaMensual r
where year(r.FechaCancelacion)=year(getdate())
order by r.RentaId desc
for xml path('')),1,1,''))
end
end
GO
/****** Object:  StoredProcedure [dbo].[insertartemLetra]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertartemLetra]
@CompraId numeric(38),
@ProveedorId numeric(38),
@TemporalDocumento varchar(60),
@TemporalMoneda varchar(20),
@TemporalMonto decimal(18,2),
@UsuarioId int,
@TemporalCanje varchar(80)
as
begin
insert into temporalLetra values(@CompraId,@ProveedorId,@TemporalDocumento,@TemporalMoneda,
@TemporalMonto,@UsuarioId,@TemporalCanje)
end
GO
/****** Object:  StoredProcedure [dbo].[insertarTempCompra]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarTempCompra]
@UsuarioID int,
@IdProducto numeric(20),
@DetalleCodigo varchar(80),
@Descripcion varchar(255),
@DetalleUM   varchar(60),
@DetalleCantidad decimal(18,2),
@PrecioCosto  decimal(18,4),
@DetalleImporte decimal(18,2),
@DetalleDescuento decimal(18,4),
@DetalleEstado varchar(40)
--@ValorUM decimal(18,4)
as
begin
insert into TemporalCompra values(@UsuarioID,@IdProducto,@DetalleCodigo,
@Descripcion,@DetalleUM,@DetalleCantidad,@PrecioCosto,@DetalleImporte,
@DetalleDescuento,@DetalleEstado,1)
end
GO
/****** Object:  StoredProcedure [dbo].[insertarTempCompraB]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarTempCompraB]
@Data varchar(max)
as
begin
Declare @p1 int,@p2 int,
        @p3 int,@p4 int,
        @p5 int,@p6 int,
        @p7 int,@p8 int,
        @p9 int,@p10 int,
        @p11 int
Declare @UsuarioID int,@IdProducto numeric(20),
		@DetalleCodigo varchar(80),@Descripcion varchar(255),
		@DetalleUM varchar(60),@DetalleCantidad decimal(18,2),
		@PrecioCosto  decimal(18,4),@DetalleImporte decimal(18,2),
		@DetalleDescuento decimal(18,4),@DetalleEstado varchar(40),
		@ValorUM decimal(18,4)
Set @Data = LTRIM(RTrim(@Data))
Set @p1 = CharIndex('|',@Data,0)
Set @p2 = CharIndex('|',@Data,@p1+1)
Set @p3= CharIndex('|',@Data,@p2+1)
Set @p4= CharIndex('|',@Data,@p3+1)
Set @p5= CharIndex('|',@Data,@p4+1)
Set @p6= CharIndex('|',@Data,@p5+1)
Set @p7= CharIndex('|',@Data,@p6+1)
Set @p8= CharIndex('|',@Data,@p7+1)
Set @p9= CharIndex('|',@Data,@p8+1)
Set @p10= CharIndex('|',@Data,@p9+1)
Set @p11 = Len(@Data)+1
Set @UsuarioID =convert(int,SUBSTRING(@Data,1,@p1-1))
Set @IdProducto=convert(numeric(20),SUBSTRING(@Data,@p1+1,@p2-@p1-1))
Set @DetalleCodigo=SUBSTRING(@Data,@p2+1,@p3-@p2-1)
Set @Descripcion=SUBSTRING(@Data,@p3+1,@p4-@p3-1)
Set @DetalleUM=SUBSTRING(@Data,@p4+1,@p5-@p4-1)
Set @DetalleCantidad=convert(decimal(18,2),SUBSTRING(@Data,@p5+1,@p6-@p5-1))
Set @PrecioCosto=convert(decimal(18,4),SUBSTRING(@Data,@p6+1,@p7-@p6-1))
Set @DetalleImporte=convert(decimal(18,2),SUBSTRING(@Data,@p7+1,@p8-@p7-1))
Set @DetalleDescuento=convert(decimal(18,4),SUBSTRING(@Data,@p8+1,@p9-@p8-1))
Set @DetalleEstado=SUBSTRING(@Data,@p9+1,@p10-@p9-1)
Set @ValorUM=convert(decimal(18,4),SUBSTRING(@Data,@p10+1,@p11-@p10-1))
insert into TemporalCompra values(@UsuarioID,@IdProducto,@DetalleCodigo,
@Descripcion,@DetalleUM,@DetalleCantidad,@PrecioCosto,@DetalleImporte,
@DetalleDescuento,@DetalleEstado,@ValorUM)
select
isnull((select STUFF ((select '¬'+convert(varchar,t.TemporalId)+'|'+convert(varchar,t.IdProducto)+'|'+
t.DetalleCodigo+'|'+t.Descripcion+'|'+t.DetalleUM+'|'+
CONVERT(VarChar(50),cast(t.DetalleCantidad as money ), 1)+'|'+
convert(varchar,t.PrecioCosto)+'|'+convert(varchar,t.DetalleDescuento)
+'|'+convert(varchar,t.DetalleImporte)+'|'+CONVERT(varchar,t.ValorUM)+'|'+
t.DetalleEstado
from TemporalCompra t 
inner join Producto p 
on p.IdProducto=t.IdProducto 
where t.UsuarioID=@UsuarioID
order by t.TemporalId asc
for xml path('')),1,1,'')),'~')+'['+
isnull((select STUFF ((select '¬'+convert(varchar,u.IdUm)+'|'+convert(varchar,u.IdProducto)+'|'+
u.UMDescripcion+'|'+CONVERT(VarChar(50), cast(u.ValorUM as money ), 1)+'|'+
convert(varchar,t.PrecioCosto)
from UnidadMedida u
inner join TemporalCompra t
on t.IdProducto=u.IdProducto
where t.UsuarioID=@UsuarioID
order by u.ValorUM asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[insertarTempoGuia]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarTempoGuia]
@UsuarioID int,
@IdProducto numeric(20),
@cantidad decimal(18,2),
@precioventa decimal(18,2),
@importe decimal(18,2),
@Concepto varchar(60),
@CantidadSaldo decimal(18,2),
@ClienteId numeric(20),
@DetalleId numeric(38),
@DetalleUM varchar(40),
@ValorUM decimal(18,4)
as
begin
insert into TemporalGuia values(@UsuarioID,@IdProducto,@cantidad,
@precioventa,@importe,@Concepto,@CantidadSaldo,@ClienteId,@DetalleId,@DetalleUM,@ValorUM)
end
GO
/****** Object:  StoredProcedure [dbo].[insertarTempoVenta]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarTempoVenta]
	@UsuarioID int,
	@IdProducto numeric(20),
	@cantidad decimal(18,2),
	@precioventa decimal(18,2),
	@importe decimal(18,2),
	@ValorUM decimal(18,4),
	@UniMedida varchar(40)
	as
	begin
	insert into TemporalVenta values(@UsuarioID,@IdProducto,
	@cantidad,@precioventa,@importe,@ValorUM,@UniMedida)
	end
GO
/****** Object:  StoredProcedure [dbo].[insertarTemUMGuia]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarTemUMGuia]
@Data varchar(max)
as
	Declare @pos1 int
	Declare @pos2 int
	Declare @pos3 int
	Declare @pos4 int
	Declare @pos5 int
	Declare @pos6 int
	Declare @pos7 int
	Declare @pos8 int
Declare 
@UsuarioID int,
@IdProducto numeric(20),
@cantidad decimal(18,2),
@precioventa decimal(18,2),
@importe decimal(18,2),
@Concepto varchar(60),
@DetalleUM varchar(40),
@ValorUM decimal(18,4)
Set @Data = LTRIM(RTrim(@Data))
Set @pos1 = CharIndex('|',@Data,0)
Set @UsuarioID=convert(int,SUBSTRING(@Data,1,@pos1-1))
Set @pos2 = CharIndex('|',@Data,@pos1+1)
Set @IdProducto=convert(numeric(20),SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))
Set @pos3 = CharIndex('|',@Data,@pos2+1)
Set @cantidad=convert(decimal(18,2),SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1))
Set @pos4 = CharIndex('|',@Data,@pos3+1)
Set @precioventa=convert(decimal(18,2),SUBSTRING(@Data,@pos3+1,@pos4-@pos3-1))
Set @pos5 = CharIndex('|',@Data,@pos4+1)
Set @importe=convert(decimal(18,2),SUBSTRING(@Data,@pos4+1,@pos5-@pos4-1))
Set @pos6 =CharIndex('|',@Data,@pos5+1)
Set @Concepto=SUBSTRING(@Data,@pos5+1,@pos6-@pos5-1)
Set @pos7=CharIndex('|',@Data,@pos6+1)
Set @DetalleUM=SUBSTRING(@Data,@pos6+1,@pos7-@pos6-1)
Set @pos8= Len(@Data)+1
Set @ValorUM=convert(decimal(18,4),SUBSTRING(@Data,@pos7+1,@pos8-@pos7-1))
IF EXISTS(select t.DetalleUM from TemporalGuia t where (t.IdProducto=@IdProducto and t.DetalleUM=@DetalleUM)and t.UsuarioID=@UsuarioID)
begin
select 'UM'
end
else
begin
insert into TemporalGuia values(@UsuarioID,@IdProducto,@cantidad,
@precioventa,@importe,@Concepto,0,0,0,@DetalleUM,@ValorUM)
select 'true'
end
GO
/****** Object:  StoredProcedure [dbo].[insertarTemVenta]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertarTemVenta]
	@UsuarioID int,
	@IdProducto numeric(20),
	@cantidad decimal(18,2),
	@precioventa decimal(18,2),
	@importe decimal(18,2),
	@ValorUM decimal(18,2),
	@UniMedida varchar(40)
	as
	begin
	insert into TemporalVenta values(@UsuarioID,@IdProducto,@cantidad,@precioventa,@importe,@ValorUM,@UniMedida)
	end
GO
/****** Object:  StoredProcedure [dbo].[InsertarUM]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[InsertarUM]
@Data varchar(max)
as
begin
Declare @pos1 int
Declare @pos2 int
Declare @pos3 int
Declare @pos4 int
Declare @pos5 int
Declare @pos6 int
Declare @pos7 int
declare @IdUm int,
@IdProducto numeric(20),
@UMDescripcion varchar(80),
@ValorUM decimal(18,4),
@PrecioVenta decimal(18,2),
@PrecioVentaB decimal(18,2),
@PrecioCosto decimal(18,4)
Set @Data = LTRIM(RTrim(@Data))
Set @pos1 = CharIndex('|',@Data,0)
Set @IdUm =convert(int,SUBSTRING(@Data,1,@pos1-1))
Set @pos2 = CharIndex('|',@Data,@pos1+1)
Set @IdProducto=convert(numeric,SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))
Set @pos3 = CharIndex('|',@Data,@pos2+1)
Set @UMDescripcion=SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1)
Set @pos4 = CharIndex('|',@Data,@pos3+1)
Set @ValorUM=convert(decimal(18,4),SUBSTRING(@Data,@pos3+1,@pos4-@pos3-1))
Set @pos5 = CharIndex('|',@Data,@pos4+1)
Set @PrecioVenta=convert(decimal(18,2),SUBSTRING(@Data,@pos4+1,@pos5-@pos4-1))
Set @pos6 =CharIndex('|',@Data,@pos5+1)
Set @PrecioVentaB=convert(decimal(18,2),SUBSTRING(@Data,@pos5+1,@pos6-@pos5-1))
Set @pos7 = Len(@Data)+1
Set @PrecioCosto=convert(decimal(18,4),SUBSTRING(@Data,@pos6+1,@pos7-@pos6-1))
declare @CostoPro decimal(18,4),@costoTotal decimal(18,4)
set @CostoPro=(select top 1 p.ProductoCosto from Producto p where p.IdProducto=@IdProducto)
set @costoTotal=@ValorUM * @CostoPro
if @IdUm=0
begin
IF EXISTS(select u.UMDescripcion from UnidadMedida u where u.IdProducto=@IdProducto and u.UMDescripcion=@UMDescripcion)
select 'UM'
else IF EXISTS(select u.ValorUM from UnidadMedida u where u.IdProducto=@IdProducto and u.ValorUM=@ValorUM)
select 'VALOR'
else
begin
insert into UnidadMedida values(@IdProducto,@UMDescripcion,@ValorUM,@PrecioVenta,@PrecioVentaB,@costoTotal)
(select STUFF ((select '¬'+convert(varchar,m.IdUm)+'|'+CONVERT(varchar,m.IdProducto)+'|'+m.UMDescripcion+'|'+
CONVERT(VarChar(50),cast(m.ValorUM as money ),2)+'|'+CONVERT(VarChar(50),cast(m.PrecioVenta as money ), 1)+'|'+CONVERT(VarChar(50), cast(m.PrecioVentaB as money ), 1)+'|'+
CONVERT(varchar(50),m.PrecioCosto)
from UnidadMedida m
where m.IdProducto=@IdProducto
order by m.ValorUM asc
for xml path('')),1,1,''))
end
end
else
begin
update UnidadMedida
set PrecioVenta=@PrecioVenta,PrecioVentaB=@PrecioVentaB,PrecioCosto=@PrecioCosto
where IdUm=@IdUm
select 'true'
end
end
GO
/****** Object:  StoredProcedure [dbo].[insertaTemLiVenta]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertaTemLiVenta]
@DocuId numeric(38),
@NotaId numeric(38),
@UsuarioId int,
@SaldoDocu decimal(18,2),
@TipoCambio decimal(18,3),
@EfectivoSoles decimal(18,2),
@EfectivoDolar decimal(18,2),
@DepositoSoles decimal(18,2),
@DepositoDolar decimal(18,2),
@EntidadBanco varchar(80),
@NroOperacion varchar(80),
@AcuentaGeneral decimal(18,2),
@TemporalFecha varchar(60)
as
begin
insert into TemporalLiVenta values(@DocuId,@NotaId,@UsuarioId,@SaldoDocu,@TipoCambio,@EfectivoSoles,
@EfectivoDolar,@DepositoSoles,@DepositoDolar,@EntidadBanco,@NroOperacion,@AcuentaGeneral,
@TemporalFecha)
end
GO
/****** Object:  StoredProcedure [dbo].[insertaTempoLiquida]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertaTempoLiquida]
@IdDeuda numeric(38, 0),
@Numero varchar(60),
@Proveedor varchar(255),
@SaldoDocu decimal(18, 2),
@Moneda varchar(20),
@TipoCambio decimal(18, 3),
@EfectivoSoles decimal(18, 2),
@EfectivoDolar decimal(18, 2),
@DepositoSoles decimal(18, 2),
@DepositoDolar decimal(18, 2),
@EntidadBanco varchar(80),
@NroOperacion varchar(80),
@AcuentaGeneral decimal(18, 2),
@TemporalFecha varchar(60),
@UsuarioId int,
@Concepto varchar(40)
as
begin
insert into TemporalLiquida values
(@IdDeuda,@Numero,@Proveedor,@SaldoDocu,@Moneda,@TipoCambio,
@EfectivoSoles,@EfectivoDolar,@DepositoSoles,@DepositoDolar,
@EntidadBanco,@NroOperacion,@AcuentaGeneral,@TemporalFecha,@UsuarioId,@Concepto)
end
GO
/****** Object:  StoredProcedure [dbo].[insertaTemporalUM]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertaTemporalUM]
@Data varchar(max)
as
begin
Declare @pos1 int
Declare @pos2 int
Declare @pos3 int
Declare @pos4 int
Declare @pos5 int
Declare @pos6 int
Declare @pos7 int
Declare @pos8 int
declare @pos9 int
declare @pos10 int
declare @pos11 int
	declare @temporalId numeric(38),
	@UsuarioID int,
	@IdProducto numeric(20),
	@cantidad decimal(18,2),
	@precioventa decimal(18,2),
	@importe decimal(18,2),
	@ValorUM decimal(18,4),
	@UniMedida varchar(40),
	@Descripcion varchar(140),
	@NotaId numeric(38),
    @Aviso char(1)
Set @Data = LTRIM(RTrim(@Data))
Set @pos1 = CharIndex('|',@Data,0)
Set @temporalId =convert(numeric(38),SUBSTRING(@Data,1,@pos1-1))
Set @pos2 = CharIndex('|',@Data,@pos1+1)
Set @UsuarioID=convert(int,SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))
Set @pos3 = CharIndex('|',@Data,@pos2+1)
Set @IdProducto=convert(numeric(20),SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1))
Set @pos4 = CharIndex('|',@Data,@pos3+1)
Set @cantidad=convert(decimal(18,2),SUBSTRING(@Data,@pos3+1,@pos4-@pos3-1))
Set @pos5 = CharIndex('|',@Data,@pos4+1)
Set @precioventa=convert(decimal(18,2),SUBSTRING(@Data,@pos4+1,@pos5-@pos4-1))
Set @pos6 =CharIndex('|',@Data,@pos5+1)
Set @importe=convert(decimal(18,2),SUBSTRING(@Data,@pos5+1,@pos6-@pos5-1))
Set @pos7 =CharIndex('|',@Data,@pos6+1)
Set @ValorUM=convert(decimal(18,4),SUBSTRING(@Data,@pos6+1,@pos7-@pos6-1))
Set @pos8 =CharIndex('|',@Data,@pos7+1)
Set @UniMedida=SUBSTRING(@Data,@pos7+1,@pos8-@pos7-1)
Set @pos9=CharIndex('|',@Data,@pos8+1)
Set @Descripcion=SUBSTRING(@Data,@pos8+1,@pos9-@pos8-1)
Set @pos10=CharIndex('|',@Data,@pos9+1)
Set @NotaId=convert(numeric(38),SUBSTRING(@Data,@pos9+1,@pos10-@pos9-1))
Set @pos11= Len(@Data)+1
Set @Aviso=SUBSTRING(@Data,@pos10+1,@pos11-@pos10-1)
declare @costo decimal(18,2)
set @costo=(select p.ProductoCosto from Producto p where p.IdProducto=@IdProducto)
if @Aviso='G'
begin
IF EXISTS(select t.UniMedida from TemporalVenta t where (t.IdProducto=@IdProducto and t.UniMedida=@UniMedida)and t.UsuarioID=@UsuarioID)
begin
select 'UM'
end
else
begin
insert into TemporalVenta values(@UsuarioID,@IdProducto,@cantidad,@precioventa,@importe,@ValorUM,@UniMedida)
select 'true'
end
end
else
begin
IF EXISTS(select d.DetalleUm from DetallePedido d where (d.IdProducto=@IdProducto and d.DetalleUm=@UniMedida)and d.NotaId=@NotaId)
begin
select 'UM'
end
else
begin
insert into DetallePedido values(@NotaId,@IdProducto,@cantidad,@UniMedida,@Descripcion,@costo,@precioventa,@importe,'PENDIENTE',0,@ValorUM)
select 'true'
end
end
end
GO
/****** Object:  StoredProcedure [dbo].[insertaTipoCambio]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertaTipoCambio]
@Data varchar(max)
as
begin
	Declare @pos1 int
	Declare @pos2 int
	Declare @pos3 int
	Declare @pos4 int
	Declare @pos5 int
declare @IdTipo numeric(38),@TipoFecha date,@TipoCompra decimal(18,3),
@TipoVenta decimal(18,3),@TipoEmpresa decimal(18,3)
Set @Data = LTRIM(RTrim(@Data))
Set @pos1 = CharIndex('|',@Data,0)
Set @IdTipo =convert(numeric(38),SUBSTRING(@Data,1,@pos1-1))
Set @pos2 = CharIndex('|',@Data,@pos1+1)
Set @TipoFecha=convert(date,SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))
Set @pos3 = CharIndex('|',@Data,@pos2+1)
Set @TipoCompra=convert(decimal(18,3),SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1))
Set @pos4 = CharIndex('|',@Data,@pos3+1)
Set @TipoVenta=convert(decimal(18,3),SUBSTRING(@Data,@pos3+1,@pos4-@pos3-1))
Set @pos5= Len(@Data)+1
Set @TipoEmpresa=convert(decimal(18,3),SUBSTRING(@Data,@pos4+1,@pos5-@pos4-1))
if(@IdTipo=0)
begin
IF EXISTS(select * from TipoCambio where TipoFecha=@TipoFecha)
	select 'false'
else
begin
	insert TipoCambio values(@TipoFecha,@TipoCompra,@TipoVenta,@TipoEmpresa)
	select isnull((select STUFF((select '¬'+ convert(varchar,t.IdTipo),+'|'+
	(Convert(char(10),t.TipoFecha,103))+'|'+convert(varchar,t.TipoCompra)+'|'+
	convert(varchar,t.TipoVenta)+'|'+
	convert(varchar,t.TipoEmpresa) 
	from TipoCambio t 
	where MONTH(t.TipoFecha)=MONTH(GETDATE()) and YEAR(t.TipoFecha)=YEAR(GETDATE()) 
	order by t.TipoFecha desc
	for xml path('')),1,1,'')),'~')	
end
end
else
begin
update TipoCambio
set TipoFecha=@TipoFecha,TipoCompra=@TipoCompra,TipoVenta=@TipoVenta,TipoEmpresa=@TipoEmpresa
where IdTipo=@IdTipo
select 'true'
end
end
GO
/****** Object:  StoredProcedure [dbo].[KardeProveedor]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[KardeProveedor]
@IdProducto numeric(20),
@fechainicio date,
@fechafin date
as
begin
select p.ProveedorId,p.ProveedorRazon,(Convert(char(10),c.CompraEmision,103)) as FechaEmision,
substring(t.TipoDescripcion,1,1)+'-C  '+c.CompraSerie+'-'+c.CompraNumero as Numero,
c.CompraTipoCambio as TipoCambio,CONVERT(VarChar(50), cast(d.DetalleCantidad as money ), 1)as Cantidad,
substring(d.DetalleUM,1,3) as UM,	
case when(CompraMoneda='DOLARES')then 
case when(CompraTipoIgv='DISGREGADO')then
cast((((((d.DetalleImporte-d.DetalleDescuento)/d.DetalleCantidad)*1)*1.18)- d.DescuentoB) as decimal(18,4))
else
cast(((cast(((d.DetalleImporte-d.DetalleDescuento)/d.DetalleCantidad)as decimal(18,4))-d.DescuentoB)*1) as decimal(18,4))
end
else
case when(CompraTipoIgv='DISGREGADO') then
cast(((((d.DetalleImporte-d.DetalleDescuento)/d.DetalleCantidad)*1.18)-d.DescuentoB) as decimal(18,4))
else 
cast((((d.DetalleImporte-d.DetalleDescuento)/d.DetalleCantidad)-d.DescuentoB)as decimal(18,4)) 
end end as CostoSoles,
------
case when(CompraMoneda='DOLARES')then 
case when(CompraTipoIgv='DISGREGADO')then
cast(((((d.DetalleImporte-d.DetalleDescuento)/d.DetalleCantidad)*1.18)-d.DescuentoB) as decimal(18,4))
else 
cast((((d.DetalleImporte-d.DetalleDescuento)/d.DetalleCantidad)-d.DescuentoB) as decimal(18,4))
end
else 
case when(CompraTipoIgv='DISGREGADO')then 
cast((((((d.DetalleImporte-d.DetalleDescuento)/d.DetalleCantidad)/1)*1.18)-d.DescuentoB) as decimal(18,4))
else 
cast(((((d.DetalleImporte-d.DetalleDescuento)/d.DetalleCantidad)/1)-d.DescuentoB) as decimal(18,4))
end end as CostoDolar
from DetalleCompra d
inner join Compras c
on c.CompraId=d.CompraId
inner join Proveedor p
on p.ProveedorId=c.ProveedorId
inner join TipoComprobante t
on t.TipoCodigo=c.TipoCodigo
where(Convert(char(10),c.CompraEmision,103) BETWEEN @fechainicio AND @fechafin) and d.IdProducto=@IdProducto
order by 1 desc,c.CompraEmision desc
end
GO
/****** Object:  StoredProcedure [dbo].[kardexCompra]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[kardexCompra] 
@ProveedorId numeric(38),
@Asociado varchar(60),
@CompraId numeric(38)
as
begin
select (Convert(char(10),c.CompraEmision,103)) as FechaPago,c.CompraId,
'NC '+c.CompraSerie+'-'+c.CompraNumero as Documento,c.CompraMoneda as Moneda,
CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1)as Acuenta,c.CompraTotal
from Compras c
where (c.ProveedorId=@ProveedorId and (c.CompraAsociado)=@Asociado)
union all
select d.FechaPago,d.CompraId,'LQ '+l.LiquidacionNumero as Documento,c.CompraMoneda as Moneda,
CONVERT(VarChar(50), cast(d.AcuentaGeneral as money ), 1)as Acuenta,d.AcuentaGeneral
from DetalleLiquida d
inner join Liquidacion l
on l.LiquidacionId=d.LiquidacionId
inner join Compras c
on c.CompraId=d.CompraId
where c.CompraId=@CompraId
order by 6 desc
end
GO
/****** Object:  StoredProcedure [dbo].[Ld_listaAlmacen]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Ld_listaAlmacen]
as
begin
select 
'Id|Almacen|Departamento|Provincia|Distrito|Direccion|Estado¬80|435|100|100|100|100|100¬String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+ convert(varchar,a.AlmacenId)+'|'+a.AlmacenNombre+'|'+a.AlmacenDepartamento+'|'+
a.AlmacenProvincia+'|'+a.AlmacenDistrito+'|'+a.AlmacenDireccion+'|'+a.AlmacenEstado
from Almacen a
order by AlmacenId desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[ldBloques]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ldBloques]
as
begin
declare @fechaReferencia date
set @fechaReferencia=(select top 1 n.NotaFecha from NotaPedido n
where (n.NotaCondicion='ALCONTADO' and n.NotaEntrega='INMEDIATA' and n.NotaFormaPago='EFECTIVO')and
(n.NotaEstado<>'ANULADO'and(n.NotaConcepto='MERCADERIA' and(((n.NotaEstado<>'CANCELADO' and n.NotaAcuenta<=0) AND n.NotaDocu <>'PROFORMA'))))
group by n.NotaFecha
order by n.NotaFecha asc)
select
'NotaId|Usuario|FechaEmision|Documento|ClienteRazon|Saldo|Total¬100|150|150|135|400|120|120¬String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+convert(varchar,n.NotaId)+'|'+n.NotaUsuario+'|'+
(IsNull(convert(varchar,n.NotaFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,n.NotaFecha,114),1,8),''))+'|'+
n.NotaDocu+'|'+c.ClienteRazon+'|'+
CONVERT(VarChar(50), cast(n.NotaSaldo as money ), 1)+'|'+
CONVERT(VarChar(50), cast(n.NotaPagar as money ), 1)
from NotaPedido n
inner join Cliente c
on c.ClienteId=n.ClienteId
where convert(date,n.NotaFecha)=@fechaReferencia and(n.NotaCondicion='ALCONTADO' and n.NotaEntrega='INMEDIATA' and n.NotaFormaPago='EFECTIVO')and
(n.NotaEstado<>'ANULADO'and(n.NotaConcepto='MERCADERIA' and(((n.NotaEstado<>'CANCELADO' and n.NotaAcuenta<=0) AND n.NotaDocu <>'PROFORMA'))))
order by n.NotaId asc
FOR XML path ('')),1,1,'')),'~')+'_'+
'NotaId|FechaEmision|Documento|Vendedor|IdPro|Cantidad|UM|Descripcion|PrecioVenta|PrecioCosto|Importe|ValorUM¬95|153|105|150|70|100|60|330|100|100|110|100¬String|String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF(( select '¬'+ convert(varchar,d.NotaId)+'|'+
(IsNull(convert(varchar,n.NotaFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,n.NotaFecha,114),1,8),''))+'|'+
n.NotaDocu+'|'+n.NotaUsuario+'|'+
convert(varchar,d.IdProducto)+'|'+
CONVERT(VarChar(50), cast(d.DetalleCantidad as money ), 1)+'|'+
d.DetalleUm+'|'+d.DetalleDescripcion+'|'+
CONVERT(VarChar(50), cast(d.DetallePrecio as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DetalleCosto as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DetalleImporte as money ), 1)+'|'+
CONVERT(varchar,d.ValorUM)
from DetallePedido d
inner join NotaPedido n
on n.NotaId=d.NotaId
where convert(date,n.NotaFecha)=@fechaReferencia and(n.NotaCondicion='ALCONTADO' and n.NotaEntrega='INMEDIATA' and n.NotaFormaPago='EFECTIVO')and
(n.NotaEstado<>'ANULADO'and(n.NotaConcepto='MERCADERIA' and(((n.NotaEstado<>'CANCELADO' and n.NotaAcuenta<=0) AND n.NotaDocu <>'PROFORMA'))))
order by n.NotaId asc
FOR XML PATH('')), 1, 1, '')),'~')+'_'+
isnull((select STUFF((select '¬'+CONVERT(varchar,c.CajaId)
from Caja c
where CajaEstado='ACTIVO'
FOR XML path ('')),1,1,'')),'0')+'_'+
isnull((select top 15 STUFF((select top 15 '¬'+convert(varchar,b.BloqueId)+'|'+
(IsNull(convert(varchar,b.BloqueFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,b.BloqueFecha,114),1,8),''))
from Bloque b
order by b.BloqueId desc
FOR XML path ('')),1,1,'')),'')
end
GO
/****** Object:  StoredProcedure [dbo].[LDdocumentos]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[LDdocumentos]
@Mes int,
@ANNO int
as
begin
select 'Compania|Fecha|Documento|NroDoc|Cliente|RUC|DNI|SubTotal|IGV|ICBPER|Total|Usuario|Estado|Referencia|Codigo|Mensaje¬65|85|90|110|250|80|80|110|110|95|110|150|150|110|0|0¬'+
(select STUFF((select '¬'+convert(varchar,d.CompaniaId)
+'|'+(Convert(char(10),d.DocuEmision,103))+'|'+
d.DocuDocumento+'|'+
convert(varchar,d.DocuSerie+'-'+d.DocuNumero)+'|'+
c.ClienteRazon+'|'+isnull(c.ClienteRuc,'')+'|'+isnull(c.ClienteDni,'')+'|'+
case when(d.TipoCodigo='07')then 
'-'+CONVERT(VarChar(50), cast(d.DocuSubTotal as money ), 1)
else
CONVERT(VarChar(50), cast(d.DocuSubTotal as money ), 1)end+'|'+
case when (d.TipoCodigo='07')then
'-'+CONVERT(VarChar(50), cast(d.DocuIgv as money), 1)
else
CONVERT(VarChar(50), cast(d.DocuIgv as money), 1)end+'|'+
case when (d.TipoCodigo='07')then
'-'+CONVERT(VarChar(50), cast(d.ICBPER as money), 1)
else
CONVERT(VarChar(50), cast(d.ICBPER as money), 1)end+'|'+
case when (d.TipoCodigo='07')then
'-'+CONVERT(VarChar(50), cast(d.DocuTotal as money ), 1)
else
CONVERT(VarChar(50), cast(d.DocuTotal as money ), 1)end+'|'+
d.DocuUsuario+'|'+d.DocuEstado+'|'+d.DocuNroGuia+'|'+
CodigoSunat+'|'+MensajeSunat
from DocumentoVenta d
inner join Cliente c
on c.ClienteId=d.ClienteId
where (Month(d.DocuEmision)=@Mes and YEAR(d.DocuEmision)=@ANNO) and (d.DocuDocumento<>'NOTA PEDIDO' and d.DocuDocumento<>'PROFORMA V' and d.DocuDocumento<>'PROFORMA')
order by d.DocuEmision asc,d.DocuSerie+'-'+d.DocuNumero asc
FOR XML PATH('')), 1, 1, ''))
end
GO
/****** Object:  StoredProcedure [dbo].[LdGanancia]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[LdGanancia] 
@NotaId numeric(38)
as
begin
declare @Estado varchar(80)
set @Estado=(select top 1 n.NotaEstado from NotaPedido n where n.NotaId=@NotaId)
select 
'FechaEmision|Vendedor|Descripcion|Cantidad|UM|PrecioUni|PreCosto|GXUnidad|Importe|Ganancia¬150|150|385|110|70|110|110|110|0|120¬'+
(select STUFF((select '¬'+(IsNull(convert(varchar,n.NotaFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,n.NotaFecha,114),1,8),''))+'|'+
n.NotaUsuario+'|'+d.DetalleDescripcion+'|'+
CONVERT(VarChar(50), cast((d.DetalleCantidad) as money ), 1)+'|'+d.DetalleUm+'|'+
CONVERT(VarChar(50), cast(d.DetallePrecio as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DetalleCosto as money ), 1)+'|'+
CONVERT(VarChar(50), cast((d.DetallePrecio-d.DetalleCosto) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((d.DetalleImporte) as money ), 1)+'|'+
CONVERT(VarChar(50), cast(((d.DetallePrecio-d.DetalleCosto)* d.DetalleCantidad) as money ), 1)
from DetallePedido d (noLOCK) 
inner join NotaPedido n (noLOCK)
on n.NotaId=d.NotaId
where d.NotaId=@NotaId
order by d.DetalleId asc
for xml path('')),1,1,''))
end
GO
/****** Object:  StoredProcedure [dbo].[LDrptCompra]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[LDrptCompra] 
@Mes varchar(60),
@ANNO int
as
begin
select 'Compania|FechaEmision|Documento|RUC|RazonSocial|Tipo|BaseImp|IGV|Total|Moneda|TipoSunat|Monto|Referencia¬
68|95|110|90|330|45|105|105|105|85|75|105|110¬'+
(select stuff((select '¬'+CONVERT(varchar,c.CompaniaId)+'|'+(Convert(char(10),c.CompraEmision,103))+'|'+
(c.CompraSerie+'-'+c.CompraNumero)+'|'+
p.ProveedorRuc+'|'+p.ProveedorRazon+'|'+c.TipoCodigo+'|'+
case when c.CompraMoneda='DOLARES' THEN
case when c.TipoCodigo='07' then
'-'+CONVERT(VarChar(50), cast((c.CompraTotal/1.18)*c.CompraTipoSunat as money ), 1)
else
 CONVERT(VarChar(50), cast((c.CompraTotal/1.18)*c.CompraTipoSunat as money ), 1)end
else  
case when c.TipoCodigo='07' then
'-'+CONVERT(VarChar(50), cast((c.CompraTotal/1.18) as money ), 1)
else
CONVERT(VarChar(50), cast((c.CompraTotal/1.18) as money ), 1)end
end+'|'+
case when c.CompraMoneda='DOLARES' then
case when c.TipoCodigo='07' then
'-'+CONVERT(VarChar(50), cast((c.CompraTotal-(c.CompraTotal/1.18))*c.CompraTipoSunat as money ), 1)
else
 CONVERT(VarChar(50), cast((c.CompraTotal-(c.CompraTotal/1.18))*c.CompraTipoSunat as money ), 1)end
else 
case when c.TipoCodigo='07' then
'-'+CONVERT(VarChar(50), cast((c.CompraTotal-(c.CompraTotal/1.18))as money ), 1)
else
CONVERT(VarChar(50), cast((c.CompraTotal-(c.CompraTotal/1.18))as money ), 1)end
end+'|'+
case when c.CompraMoneda='DOLARES' then
case when c.TipoCodigo='07' then
'-'+CONVERT(VarChar(50), cast((c.CompraTotal *c.CompraTipoSunat) as money ), 1)
else
CONVERT(VarChar(50), cast((c.CompraTotal *c.CompraTipoSunat) as money ), 1) end
else 
case when c.TipoCodigo='07' then
'-'+CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1)
else
CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1)end
end+'|'+
c.CompraMoneda+'|'+convert(varchar,c.CompraTipoSunat)+'|'+
case when c.TipoCodigo='07' then
'-'+CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1)
else
CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1)
end+'|'+CompraAsociado
from Compras c
inner join Proveedor p
on p.ProveedorId=c.ProveedorId
where (DATENAME(month,c.CompraComputo)=@Mes and YEAR(c.CompraComputo)=@ANNO) and(c.TipoCodigo='01' or c.TipoCodigo='07')
order by c.CompraEmision asc
FOR XML PATH('')), 1, 1, ''))
end
GO
/****** Object:  StoredProcedure [dbo].[ldTraerDetalle]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ldTraerDetalle]
@Data varchar(max)
as
begin
declare @p0 int, 
        @p1 int
declare @IdProducto numeric(20),
		@NotaId numeric(38),
		@Ganancia decimal(18,2)
		set @p0 = CharIndex('|',@Data,0)
        Set @p1 = Len(@Data)+1
	Set @IdProducto=Convert(numeric(20),SUBSTRING(@Data,1,@p0-1))
	Set @NotaId= Convert(numeric(38),SUBSTRING(@Data,@p0+1,@p1-@p0-1))
	set @Ganancia=(select (d.DetallePrecio - d.DetalleCosto) 
	from DetallePedido d where d.IdProducto=@IdProducto and d.NotaId=@NotaId)
begin
	update DetallePedido 
	set DetalleCantidad=DetalleCantidad + 1,
	DetalleImporte=((DetalleCantidad + 1)* DetallePrecio) 
	where IdProducto=@IdProducto and NotaId=@NotaId
	update NotaPedido
	set NotaGanancia=NotaGanancia+@Ganancia
	where NotaId=@NotaId
	select 'true'
end
end
GO
/****** Object:  StoredProcedure [dbo].[LetrasVencidas]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[LetrasVencidas] 
as
begin
select p.ProveedorRazon as RazonSocial,'LT '+d.LetraCanje as Documento,
substring(l.LetraMoneda,1,1)+'/  '+CONVERT(VarChar(50),cast(d.DetalleSaldo as money ), 1) as SaldoDoc,
(Convert(char(10),d.LetraVencimiento,103)) as Vencimiento,
convert(char(10),(dateadd(DAY,6,d.LetraVencimiento)),103) as FinVencimiento,
case when ((dateadd(DAY,6,d.LetraVencimiento))<= CONVERT(date,GETDATE())) then
'VENCIDO'
else
case when (CONVERT(date,GETDATE())>=(d.LetraVencimiento)) then
'POR VENCER'
else
'PENDIENTE'
end end as Estado
from DetalleLetra d
inner join Letra l
on l.LetraId=d.LetraId
inner join Proveedor p
on p.ProveedorId=l.ProveedorId
where (d.DetalleEstado<>'TOTALMENTE PAGADO') and ((dateadd(DAY,-6,d.LetraVencimiento))<= CONVERT(date,GETDATE()))
union all
select p.ProveedorRazon as RazonSocial,substring(t.TipoDescripcion,1,1)+'C '+C.CompraSerie+' '+c.CompraNumero as Documento,
substring(c.CompraMoneda,1,1)+'/  '+CONVERT(VarChar(50),cast(c.CompraSaldo as money ), 1) as SaldoDoc,
(Convert(char(10),c.CompraFechaPago,103))as Vencimiento,(Convert(char(10),c.CompraFechaPago,103)) as FinVencimiento,
case when (CONVERT(date,GETDATE())>=(c.CompraFechaPago)) then
'VENCIDO'
else
case when ((dateadd(DAY,-2,c.CompraFechaPago))<= CONVERT(date,GETDATE())) then
'POR VENCER'
else
'PENDIENTE'
end end as Estado
from Compras c
inner join Proveedor p
on c.ProveedorId=p.ProveedorId
inner join TipoComprobante t
on t.TipoCodigo=c.TipoCodigo
where c.CompraEstado='PENDIENTE DE PAGO' and ((dateadd(DAY,-6,c.CompraFechaPago))<= CONVERT(date,GETDATE()))
end
GO
/****** Object:  StoredProcedure [dbo].[LetrasVencidasR]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[LetrasVencidasR]
as
begin
select Row_number() over(order by d.LetraVencimiento asc)as Item,p.ProveedorRazon as RazonSocial,'LT '+d.LetraCanje as LetraCanje,
l.LetraMoneda as Moneda,CONVERT(VarChar(50),cast(d.DetalleSaldo as money ), 1) as SaldoDoc,
(Convert(char(10),d.LetraVencimiento,103)) as Vencimiento,
convert(char(10),(dateadd(DAY,6,d.LetraVencimiento)),103) as FinVencimiento,
case when ((dateadd(DAY,6,d.LetraVencimiento))<= CONVERT(date,GETDATE())) then
'VENCIDO'
else
case when ((dateadd(DAY,-6,d.LetraVencimiento))<= CONVERT(date,GETDATE())) then
'POR VENCER'
else 
'PENDIENTE'
end end as Estado
from DetalleLetra d
inner join Letra l
on l.LetraId=d.LetraId
inner join Proveedor p
on p.ProveedorId=l.ProveedorId
where (d.DetalleEstado<>'TOTALMENTE PAGADO')
order by d.LetraVencimiento asc
end
GO
/****** Object:  StoredProcedure [dbo].[listaBloque]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listaBloque]
@BloqueId numeric(38)
as
begin
select
'NotaId|Usuario|FechaEmision|Documento|ClienteRazon|Saldo|Total¬100|150|150|135|400|120|120¬String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+convert(varchar,b.NotaId)+'|'+
n.NotaUsuario+'|'+
(IsNull(convert(varchar,n.NotaFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,n.NotaFecha,114),1,8),''))+'|'+
n.NotaDocu+'|'+
c.ClienteRazon+'|'+
CONVERT(VarChar(50), cast(n.NotaSaldo as money ), 1)+'|'+
CONVERT(VarChar(50), cast(n.NotaPagar as money ), 1)+'|'+
convert(varchar,b.BloqueId)
from DetalleBloque b
inner join NotaPedido n
on  n.NotaId=b.NotaId
inner join Cliente c
on c.ClienteId=n.ClienteId
where b.BloqueId=@BloqueId
FOR XML path ('')),1,1,'')),'~')+'_'+
'NotaId|FechaEmision|Documento|Vendedor|IdPro|Cantidad|UM|Descripcion|PrecioVenta|PrecioCosto|Importe|ValorUM¬95|153|105|150|70|100|60|330|100|100|110|100¬String|String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF(( select '¬'+ convert(varchar,d.NotaId)+'|'+
(IsNull(convert(varchar,n.NotaFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,n.NotaFecha,114),1,8),''))+'|'+
n.NotaDocu+'|'+n.NotaUsuario+'|'+
convert(varchar,d.IdProducto)+'|'+
CONVERT(VarChar(50), cast(d.DetalleCantidad as money ), 1)+'|'+
d.DetalleUm+'|'+d.DetalleDescripcion+'|'+
CONVERT(VarChar(50), cast(d.DetallePrecio as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DetalleCosto as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DetalleImporte as money ), 1)+'|'+
CONVERT(varchar,d.ValorUm)
from DetalleBloque b
inner join DetallePedido d
on d.NotaId=b.NotaId
inner join NotaPedido n
on n.NotaId=d.NotaId
where b.BloqueId=@BloqueId
FOR XML PATH('')), 1, 1, '')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[listaCanjeFactura]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaCanjeFactura]
as
begin
SELECT dbo.GuiaCanje.*, dbo.Compras.CompraMoneda as Moneda,(convert(varchar(50), CAST(dbo.Compras.CompraValorVenta as money), -1))as Total,
(SUBSTRING(dbo.Compras.CompraMoneda,1,1)+'/.  '+(convert(varchar(50), CAST(dbo.Compras.CompraTotal as money), -1)))as Monto,dbo.Proveedor.ProveedorRazon as Proveedor
FROM dbo.GuiaCanje INNER JOIN dbo.Compras ON dbo.GuiaCanje.CompraId = dbo.Compras.CompraId inner join dbo.Proveedor on dbo.Proveedor.ProveedorId=dbo.Compras.ProveedorId 
where year(dbo.GuiaCanje.CanjeFecha)=YEAR(GETDATE())
order by dbo.GuiaCanje.CanjeId desc
end
GO
/****** Object:  StoredProcedure [dbo].[listaCompraComputo]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listaCompraComputo]  @f1 date,@f2 date
as
begin
select c.CompraId,c.CompraCorrelativo,c.CompaniaId,c.CompraRegistro,Convert(char(10),c.CompraComputo,103)as CompraComputo,Convert(char(10),c.CompraEmision,103)as CompraEmision,p.ProveedorRazon,
p.ProveedorRuc,c.TipoCodigo,c.CompraSerie,c.CompraNumero,c.CompraCondicion,c.CompraMoneda,CompraTipoCambio,c.CompraDias,Convert(char(10),c.CompraFechaPago,103) as CompraFechaPago,
c.CompraTipoIgv,CONVERT(VarChar(50), cast(c.CompraValorVenta as money ), 1) as ValorVenta,CONVERT(VarChar(50), cast(c.CompraDescuento as money ), 1)as Descuento,CONVERT(VarChar(50), 
cast(c.CompraSubtotal as money ), 1) as Subtotal,CONVERT(VarChar(50), cast(c.CompraIgv as money ), 1) as Igv,CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1) as Total,
CONVERT(VarChar(50), cast(c.compraSaldo as money ), 1) as CompraSaldo,c.CompraUsuario,co.CompaniaRazonSocial,
c.CompraEstado,c.ProveedorId,t.TipoDescripcion,c.CompraAsociado as Asociado,CompraOBS,CompraTipoSunat as TipoSunat,
CompraConcepto as Concepto,c.CompraPercepcion as Percepcion
from Compras c
inner join Proveedor p
on p.ProveedorId=c.ProveedorId
inner join Compania co
on co.CompaniaId=c.CompaniaId
inner join TipoComprobante t
on t.TipoCodigo=c.TipoCodigo
where(c.TipoCodigo<>'07' and c.TipoCodigo<>'101')and(Convert(char(10),c.CompraComputo, 103) BETWEEN @f1 AND @f2)
order by c.CompraEmision asc
end
GO
/****** Object:  StoredProcedure [dbo].[listaCompraEmision]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listaCompraEmision] @f1 date,@f2 date
as
begin
select c.CompraId,c.CompraCorrelativo,c.CompaniaId,c.CompraRegistro,Convert(char(10),c.CompraComputo,103)as CompraComputo,Convert(char(10),c.CompraEmision,103)as CompraEmision,p.ProveedorRazon,
p.ProveedorRuc,c.TipoCodigo,c.CompraSerie,c.CompraNumero,c.CompraCondicion,c.CompraMoneda,CompraTipoCambio,c.CompraDias,Convert(char(10),c.CompraFechaPago,103) as CompraFechaPago,
c.CompraTipoIgv,CONVERT(VarChar(50), cast(c.CompraValorVenta as money ), 1) as ValorVenta,CONVERT(VarChar(50), cast(c.CompraDescuento as money ), 1)as Descuento,CONVERT(VarChar(50), 
cast(c.CompraSubtotal as money ), 1) as Subtotal,CONVERT(VarChar(50), cast(c.CompraIgv as money ), 1) as Igv,CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1) as Total,
CONVERT(VarChar(50), cast(c.compraSaldo as money ), 1) as CompraSaldo,c.CompraUsuario,co.CompaniaRazonSocial,
c.CompraEstado,c.ProveedorId,t.TipoDescripcion,c.CompraAsociado as Asociado,CompraOBS,CompraTipoSunat as TipoSunat,CompraConcepto as Concepto,
c.CompraPercepcion as Percepcion
from Compras c
inner join Proveedor p
on p.ProveedorId=c.ProveedorId
inner join Compania co
on co.CompaniaId=c.CompaniaId
inner join TipoComprobante t
on t.TipoCodigo=c.TipoCodigo
where(c.TipoCodigo<>'07' and c.TipoCodigo<>'101') and(Convert(char(10),c.CompraEmision, 103) BETWEEN @f1 AND @f2)
order by c.CompraEmision asc
end
GO
/****** Object:  StoredProcedure [dbo].[listaDetaGeneral]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaDetaGeneral] 
@IdGeneral numeric(38)
as
select
'ID|Concepto|CajaId|Fecha|Descripcion|Monto|Usuario|Imagen¬90|100|80|136|373|120|100|90¬String|String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+ convert(varchar,c.IdCaja)+'|'+c.CajaConcepto+'|'+convert(varchar,c.CajaId)+'|'+
Convert(char(10),c.CajaFecha,103)+' '+Convert(char(8),c.CajaFecha,114) 
+'|'+c.CajaDescripcion+'|'+CONVERT(VarChar(50),cast(c.CajaMonto as money), 1)+'|'+
c.CajaUsuario+'|'+c.RutaImagen 
from CajaPincipal c 
where c.CajaConcepto='INGRESO' and c.IdGeneral=@IdGeneral
order by c.IdCaja desc
for xml path('')),1,1,'')),'~')+'['+
'ID|Concepto|CajaId|Fecha|Descripcion|Monto|Usuario|Imagen¬90|100|80|135|435|125|100|90¬String|String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+ convert(varchar,c.IdCaja)+'|'+c.CajaConcepto+'|'+convert(varchar,c.CajaId)+'|'+
Convert(char(10),c.CajaFecha,103)+' '+Convert(char(8),c.CajaFecha,114) 
+'|'+c.CajaDescripcion+'|'+CONVERT(VarChar(50),cast(c.CajaMonto as money), 1)+'|'+
c.CajaUsuario+'|'+c.RutaImagen 
from CajaPincipal c 
where c.CajaConcepto='SALIDA' and c.IdGeneral=@IdGeneral
order by c.IdCaja desc
for xml path('')),1,1,'')),'~')
GO
/****** Object:  StoredProcedure [dbo].[listaDetaliquiVenta]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaDetaliquiVenta] @LiquidacionId numeric(38)
as
begin
select d.DetalleId,d.LiquidacionId,d.NotaId as DocuId,
case when n.NotaDocu='PROFORMA V' then
substring(n.NotaDocu,1,1)+'V '+convert(varchar,n.NotaId)
else substring(n.NotaDocu,1,1)+'V '+n.NotaSerie+'-'+n.NotaNumero end Numero,
c.ClienteRazon,CONVERT(VarChar(50), cast(d.SaldoDocu as money ), 1) as Saldo,'SOLES' as Moneda,d.EfectivoSoles,
d.EfectivoDolar,d.DepositoSoles,d.DepositoDolar,d.TipoCambio,d.EntidadBanco,d.NroOperacion,
CONVERT(VarChar(50), cast(d.AcuentaGeneral as money ), 1) as Acuenta,
d.FechaPago,CONVERT(VarChar(50), cast(d.SaldoActual as money ), 1)as SaldoActual,d.NotaId 
from DetaLiquidaVenta d
inner join NotaPedido n
on n.NotaId=d.NotaId
inner join Cliente c
on c.ClienteId=n.ClienteId
where d.LiquidacionId=@LiquidacionId
order by 1 asc
end
GO
/****** Object:  StoredProcedure [dbo].[listaDetalleCompra]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaDetalleCompra]
@CompraId varchar(60)
as
begin
select
'DetalleId|IdProducto|DetalleCodigo|Descripcion|UM|Cantidad|PrecioCosto|Descuento|Importe|ValorUM|Estado¬100|100|100|420|80|90|100|100|110|100|100¬String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+convert(varchar,d.DetalleId)+'|'+convert(varchar,d.IdProducto)+'|'+
d.DetalleCodigo+'|'+d.Descripcion+'|'+d.DetalleUM+'|'+CONVERT(VarChar(50),cast(d.DetalleCantidad as money ),1)+'|'+
convert(varchar,d.PrecioCosto)+'|'+convert(varchar,d.detalleDescuento)+'|'+
CONVERT(VarChar(50),cast(d.DetalleImporte as money ), 2)+'|'+CONVERT(varchar,d.ValorUM)+'|'+d.DetalleEstado
from DetalleCompra d
where d.CompraId=@CompraId
order by d.DetalleId asc
for xml path('')),1,1,'')),'~')+'['+
'IdUm|IdProducto|UNIDAD M|Valor|Costo¬100|100|100|100|100¬String|String|String|String|String¬'+
isnull((select STUFF ((select '¬'+convert(varchar,u.IdUm)+'|'+convert(varchar,u.IdProducto)+'|'+
u.UMDescripcion+'|'+CONVERT(VarChar(50), cast(u.ValorUM as money ), 1)+'|'+
convert(varchar,d.PrecioCosto)
from UnidadMedida u
inner join DetalleCompra d
on d.IdProducto=u.IdProducto
where d.CompraId=@CompraId
order by u.ValorUM asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[listaDetalleDocu]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaDetalleDocu]  
@DocuId numeric(38)  
as  
begin  
Select  
'Id|DocuId|IdProducto|Codigo|Cantidad|Unidad|Descripcion|Precio|Importe|ValorUM¬100|100|100|100|100|90|400|115|115|100¬String|String|String|String|String|String|String|String|String|String¬'+  
isnull((select STUFF ((select '¬'+convert(varchar,d.DetalleId)+'|'+convert(varchar,d.DetalleNotaId)+'|'+  
convert(varchar,d.IdProducto)+'|'+p.ProductoCodigo+'|'+convert(varchar(50),cast(d.DetalleCantidad as money),1)+'|'+  
d.DetalleUM+'|'+p.ProductoNombre+'|'+convert(varchar(50),cast(d.DetallPrecio as money),1)+'|'+  
(convert(varchar(50),CAST(d.DetalleImporte as money),1))+'|'+CONVERT(varchar,d.ValorUM)  
from DetalleDocumento d  
inner join Producto p  
on p.IdProducto=d.IdProducto  
where DocuId=@DocuId  
order by d.DetalleId asc  
for xml path('')),1,1,'')),'~')  
end
GO
/****** Object:  StoredProcedure [dbo].[listaDetalleNota]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[listaDetalleNota]      
@Data varchar(max)      
as      
begin      
Declare @NotaId numeric(20),      
        @Estado varchar(80),  
        @IGV decimal(18,2)     
Declare @p1 int,@p2 int,@p3 int     
Set @Data = LTRIM(RTrim(@Data))      
Set @p1 = CharIndex('|',@Data,0)  
Set @p2 = CharIndex('|',@Data,@p1+1)    
Set @p3 = Len(@Data)+1      
Set @NotaId=convert(numeric(20),SUBSTRING(@Data,1,@p1-1))      
Set @Estado=SUBSTRING(@Data,@p1+1,@p2-@p1-1)  
Set @IGV=convert(decimal(18,3),SUBSTRING(@Data,@p2+1,@p3-@p2-1))  
  
Declare @IgvD decimal(18,3),@IgvR decimal(18,3)  
  
set @IgvR=(@IGV/100)  
set @IgvD=@IgvR+1  
  
select      
'DetalleId|NotaId|IdProducto|Cantidad|UMedida|Descripcion|PrecioCosto|PrecioUni|Importe|Estado|ValorUM|PrecioSunat|IGVPrecio|ImporteSunat|Codigo|CodigoSunat|Linea¬100|100|100|100|100|487|100|115|120|100|100|100|100|100|100|100|100¬String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+      
isnull((select STUFF ((select '¬'+convert(varchar,d.DetalleId)+'|'+convert(varchar,d.NotaId)+'|'+convert(varchar,d.IdProducto)+'|'+      
convert(varchar(50),cast(d.DetalleCantidad as money),1)+'|'+d.DetalleUm+'|'+d.DetalleDescripcion+'|'+convert(varchar,d.DetalleCosto)+'|'+      
convert(varchar(50),cast(d.DetallePrecio as money),1)+'|'+convert(varchar(50),cast(d.DetalleImporte as money),1)+'|'+      
d.DetalleEstado+'|'+CONVERT(varchar,d.ValorUM)+'|'+  
  
convert(varchar,convert(decimal(18,6),d.DetallePrecio/@IgvD))+'|'+      
convert(varchar,(convert(decimal(18,6),d.DetallePrecio/@IgvD)* d.DetalleCantidad)*@IgvR)+'|'+      
convert(varchar,convert(decimal(18,6),d.DetallePrecio/@IgvD)* d.DetalleCantidad) +'|'+      
  
p.ProductoCodigo+'|'+s.CodigoSunat+'|'+s.NombreSublinea      
from DetallePedido d      
inner join Producto p      
on p.IdProducto=d.IdProducto      
inner join Sublinea s      
on s.IdSubLinea=p.IdSubLinea      
where d.NotaId=@NotaId and d.DetalleEstado=@Estado      
order by d.DetalleId asc      
for xml path('')),1,1,'')),'~')      
end  
GO
/****** Object:  StoredProcedure [dbo].[listaDetalleNotaB]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaDetalleNotaB]  
@Data varchar(max) 
as  
begin

Declare @NotaId varchar(38),
        @IGV decimal(18,2)   
Declare @p1 int,@p2 int   
Set @Data = LTRIM(RTrim(@Data))    
Set @p1 = CharIndex('|',@Data,0) 
Set @p2= Len(@Data)+1    
Set @NotaId=SUBSTRING(@Data,1,@p1-1)    
Set @IGV=convert(decimal(18,2),SUBSTRING(@Data,@p1+1,@p2-@p1-1))

Declare @IgvD decimal(18,2),@IgvR decimal(18,2)

set @IgvR=(@IGV/100)
set @IgvD=@IgvR+1

declare @Estado varchar(80)  
set @Estado=(select top 1 n.NotaEstado 
from NotaPedido n where n.NotaId=@NotaId)

select  
'DetalleId|NotaId|IdProducto|Codigo|Cantidad|UMedida|Descripcion|PreCosto|PrecioUni|Importe|Estado|CanSaldo|Imagen|ValorUM|PrecioSunat|IGVPrecio|ImporteSunat¬80|80|80|80|90|80|455|100|100|100|100|100|100|100|100|100|100¬String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+  
isnull((select stuff((select '¬'+convert(varchar,d.DetalleId)+'|'+  
convert(varchar,d.NotaId)+'|'+  
convert(varchar,d.IdProducto)+'|'+  
p.ProductoCodigo+'|'+  
CONVERT(VarChar(50), cast(d.DetalleCantidad as money ), 1)+'|'+  
d.DetalleUm+'|'+  
d.DetalleDescripcion+'|'+  
case when @Estado='PENDIENTE' then   
CONVERT(VarChar(50), cast((p.ProductoCosto * d.ValorUm) as money ), 1)  
else  
CONVERT(VarChar(50), cast(d.DetalleCosto as money ), 1)  
end+'|'+  
CONVERT(VarChar(50), cast(d.DetallePrecio as money ), 1)+'|'+  
CONVERT(VarChar(50), cast(d.DetalleImporte as money ), 1)+'|'+  
D.DetalleEstado+'|'+  
CONVERT(VarChar(50), cast(d.CantidadSaldo as money ), 1)+'|'+  
p.ProductoImagen+'|'+CONVERT(varchar,d.ValorUM)+'|'+  

convert(varchar,convert(decimal(18,6),d.DetallePrecio/@IgvD))+'|'+  
convert(varchar,(d.DetalleImporte - convert(decimal(18,6),d.DetalleImporte/@IgvD)))+'|'+  
convert(varchar,convert(decimal(18,6),d.DetalleImporte/@IgvD))  

from DetallePedido d  
inner join Producto p  
on p.IdProducto=d.IdProducto  
where d.NotaId=@NotaId  
order by d.DetalleId asc  
FOR XML PATH('')), 1, 1, '')),'~')+'['+  
isnull((select STUFF((select '¬'+ convert(varchar,r.GuiaId)+'|'+g.GuiaNumero  
from GuiaRelacion r  
inner join GuiaRemision g  
on g.GuiaId=r.GuiaId  
where r.NotaId=@NotaId  
order by r.DetalleId asc  
FOR XML PATH('')), 1, 1, '')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[listaDocuCompania]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaDocuCompania]
@CompaniaId int,
@fechainicio date,
@fechafin date
as
begin
select d.DocuId,d.CompaniaId,d.NotaId,d.DocuDocumento,d.docuSerie+'-'+d.DocuNumero as DocuNumero,c.ClienteId,
c.ClienteRazon,c.ClienteRuc,c.ClienteDni,c.ClienteDireccion,d.DocuNumero as Numero,
(Convert(char(10),d.DocuEmision,103))as FechaEmision,n.NotaCondicion as DocuCondicion,
d.DocuSerie as Serie,(Convert(char(10),d.DocuFechaPago,103)) as FechaPago,
d.DocuLetras,(convert(varchar(50), CAST(d.DocuSubTotal as money), -1))as DocuSubTotal,
(convert(varchar(50), CAST(d.DocuIgv as money), -1)) as DocuIgv,
(convert(varchar(50), CAST(d.DocuTotal as money), -1))as DocuTotal,d.DocuUsuario,
d.DocuEstado as DocuEstado,co.CompaniaRazonSocial as compania,d.DocuSaldo,
d.EstadoSunat as Estado,d.DocuAdicional as MDC,d.DocuHash,co.CompaniaRUC,
c.ClienteCorreo as Correo,d.DocuNroGuia as Referencia,
convert(varchar(50), CAST(d.DocuGravada as money), -1) as Gravada,
convert(varchar(50), CAST(d.DocuDescuento as money), -1) as Descuento,
convert(varchar(50), CAST(d.ICBPER as money), -1) as ICBPER
from DocumentoVenta d
inner join Compania co
on co.CompaniaId=d.CompaniaId
inner join Cliente c
on c.ClienteId=d.ClienteId
inner join NotaPedido n
on n.NotaId=d.NotaId
where d.CompaniaId=@CompaniaId and(Convert(char(10),d.DocuEmision,103) BETWEEN @fechainicio AND @fechafin)
order by d.DocuId desc
end
GO
/****** Object:  StoredProcedure [dbo].[listaDocumentos]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaDocumentos]
as
begin
select d.DocuId,d.CompaniaId,d.NotaId,d.DocuDocumento,d.docuSerie+'-'+d.DocuNumero as DocuNumero,c.ClienteId,
c.ClienteRazon,c.ClienteRuc,c.ClienteDni,c.ClienteDireccion,d.DocuNumero as Numero,
(Convert(char(10),d.DocuEmision,103))as FechaEmision,n.NotaCondicion as DocuCondicion,
d.DocuSerie as Serie,(Convert(char(10),d.DocuFechaPago,103)) as FechaPago,
d.DocuLetras,(convert(varchar(50), CAST(d.DocuSubTotal as money), -1))as DocuSubTotal,
(convert(varchar(50), CAST(d.DocuIgv as money), -1)) as DocuIgv,
(convert(varchar(50), CAST(d.DocuTotal as money), -1))as DocuTotal,d.DocuUsuario,
d.DocuEstado as DocuEstado,co.CompaniaRazonSocial as compania,d.DocuSaldo,
d.EstadoSunat as Estado,d.DocuAdicional as MDC,d.DocuHash,co.CompaniaRUC,
c.ClienteCorreo as Correo,d.DocuNroGuia as Referencia,
convert(varchar(50), CAST(d.DocuGravada as money), -1) as Gravada,
convert(varchar(50), CAST(d.DocuDescuento as money), -1) as Descuento,
convert(varchar(50), CAST(d.ICBPER as money), -1) as ICBPER
from DocumentoVenta d
inner join Compania co
on co.CompaniaId=d.CompaniaId
inner join Cliente c
on c.ClienteId=d.ClienteId
inner join NotaPedido n
on n.NotaId=d.NotaId
where Month(d.DocuEmision)=Month(GETDATE())and year(d.DocuEmision)=YEAR(Getdate())
order by d.DocuId desc
end
GO
/****** Object:  StoredProcedure [dbo].[listaGeneralFecha]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[listaGeneralFecha] 
@fechainicio date,@fechafin date
as
begin 
select
isnull((select STUFF ((select '¬'+ CONVERT(varchar,c.IdGeneral)+'|'+
(IsNull(convert(varchar,c.FechaCierre,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,c.FechaCierre,114),1,8),''))+'|'+c.Usuario+'|'+
CONVERT(varchar(50),cast(c.Ingresos as money),1)+'|'+CONVERT(varchar(50),cast(c.Salidas as money),1)+'|'+
CONVERT(varchar(50),cast(c.Total as money),1)
from CajaGeneral c
where (Convert(char(10),c.FechaCierre,103) BETWEEN @fechainicio AND @fechafin) 
order by c.IdGeneral desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[listaLiquida]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listaLiquida]
as
begin
select l.LiquidacionId,l.LiquidacionNumero,l.LiquidacionRegistro,
(Convert(char(10),l.LiquidacionFecha,103))as LiquidacionFecha,
l.LiquidacionDescripcion,l.LiquidacionCambio,
CONVERT(VarChar(50), cast(l.LiquidaEfectivoSol as money ), 1)as LiquidaEfectivoSol,
CONVERT(VarChar(50), cast(l.LiquidaDepositoSol as money ), 1)as LiquidaDepositoSol,
CONVERT(VarChar(50), cast(l.LiquidaEfectivoDol as money ), 1)as LiquidaEfectivoDol,
CONVERT(VarChar(50), cast(l.LiquidaDepositoDol as money ), 1)as LiquidaDepositoDol,
CONVERT(VarChar(50), cast(l.LiquidaTotalDol as money ), 1)as LiquidaTotalDol,
CONVERT(VarChar(50), cast(l.LiquidaTotalSol as money ), 1)as LiquidaTotalSol,
l.LiquidaUsuario
from Liquidacion l
where(month(l.LiquidacionFecha)=MONTH(GETDATE()) and YEAR(l.LiquidacionFecha)=YEAR(GETDATE()))
order by 1 desc
end
GO
/****** Object:  StoredProcedure [dbo].[listaliquidafecha]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaliquidafecha] @fechainicio date,@fechafin date
as
begin
select l.LiquidacionId,LiquidacionNumero,l.LiquidacionRegistro,
(Convert(char(10),l.LiquidacionFecha,103))as LiquidacionFecha,
l.LiquidacionDescripcion,l.LiquidacionCambio,
CONVERT(VarChar(50), cast(l.LiquidaEfectivoSol as money ), 1)as LiquidaEfectivoSol,
CONVERT(VarChar(50), cast(l.LiquidaDepositoSol as money ), 1)as LiquidaDepositoSol,
CONVERT(VarChar(50), cast(l.LiquidaEfectivoDol as money ), 1)as LiquidaEfectivoDol,
CONVERT(VarChar(50), cast(l.LiquidaDepositoDol as money ), 1)as LiquidaDepositoDol,
CONVERT(VarChar(50), cast(l.LiquidaTotalDol as money ), 1)as LiquidaTotalDol,
CONVERT(VarChar(50), cast(l.LiquidaTotalSol as money ), 1)as LiquidaTotalSol,
l.LiquidaUsuario
from Liquidacion l
where (Convert(char(10),l.LiquidacionFecha,103) BETWEEN @fechainicio AND @fechafin)
order by 1 desc
end
GO
/****** Object:  StoredProcedure [dbo].[listaliquidafechaB]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaliquidafechaB] @fechainicio date,@fechafin date
as
begin
select l.LiquidacionId,LiquidacionNumero,l.LiquidacionRegistro,
(Convert(char(10),l.LiquidacionFecha,103))as LiquidacionFecha,
l.LiquidacionDescripcion,l.LiquidacionCambio,
CONVERT(VarChar(50), cast(l.LiquidaEfectivoSol as money ), 1)as LiquidaEfectivoSol,
CONVERT(VarChar(50), cast(l.LiquidaDepositoSol as money ), 1)as LiquidaDepositoSol,
CONVERT(VarChar(50), cast(l.LiquidaEfectivoDol as money ), 1)as LiquidaEfectivoDol,
CONVERT(VarChar(50), cast(l.LiquidaDepositoDol as money ), 1)as LiquidaDepositoDol,
CONVERT(VarChar(50), cast(l.LiquidaTotalDol as money ), 1)as LiquidaTotalDol,
CONVERT(VarChar(50), cast(l.LiquidaTotalSol as money ), 1)as LiquidaTotalSol,
l.LiquidaUsuario
from LiquidacionVenta l
where (Convert(char(10),l.LiquidacionFecha,103) BETWEEN @fechainicio AND @fechafin)
order by 1 desc
end
GO
/****** Object:  StoredProcedure [dbo].[listaLiquidaVenta]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listaLiquidaVenta]
as
begin
select l.LiquidacionId,l.LiquidacionNumero,l.LiquidacionRegistro,
(Convert(char(10),l.LiquidacionFecha,103))as LiquidacionFecha,
l.LiquidacionDescripcion,l.LiquidacionCambio,
CONVERT(VarChar(50), cast(l.LiquidaEfectivoSol as money ), 1)as LiquidaEfectivoSol,
CONVERT(VarChar(50), cast(l.LiquidaDepositoSol as money ), 1)as LiquidaDepositoSol,
CONVERT(VarChar(50), cast(l.LiquidaEfectivoDol as money ), 1)as LiquidaEfectivoDol,
CONVERT(VarChar(50), cast(l.LiquidaDepositoDol as money ), 1)as LiquidaDepositoDol,
CONVERT(VarChar(50), cast(l.LiquidaTotalDol as money ), 1)as LiquidaTotalDol,
CONVERT(VarChar(50), cast(l.LiquidaTotalSol as money ), 1)as LiquidaTotalSol,
l.LiquidaUsuario
from LiquidacionVenta l
where(month(l.LiquidacionFecha)=MONTH(GETDATE()) and YEAR(l.LiquidacionFecha)=YEAR(GETDATE()))
order by 1 desc
end
GO
/****** Object:  StoredProcedure [dbo].[listaNotaComC]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listaNotaComC] @f1 date,@f2 date
as
begin
select c.CompraId,c.CompraCorrelativo,c.CompaniaId,c.CompraRegistro,Convert(char(10),c.CompraComputo,103)as CompraComputo,Convert(char(10),c.CompraEmision,103)as CompraEmision,p.ProveedorRazon,
p.ProveedorRuc,c.TipoCodigo,c.CompraSerie,c.CompraNumero,c.CompraCondicion,c.CompraMoneda,CompraTipoCambio,c.CompraDias,Convert(char(10),c.CompraFechaPago,103) as CompraFechaPago,
c.CompraTipoIgv,CONVERT(VarChar(50), cast(c.CompraValorVenta as money ), 1) as ValorVenta,CONVERT(VarChar(50), cast(c.CompraDescuento as money ), 1)as Descuento,CONVERT(VarChar(50), 
cast(c.CompraSubtotal as money ), 1) as Subtotal,CONVERT(VarChar(50), cast(c.CompraIgv as money ), 1) as Igv,CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1) as Total,
CONVERT(VarChar(50), cast(c.compraSaldo as money ), 1) as CompraSaldo,c.CompraUsuario,co.CompaniaRazonSocial,
c.CompraEstado,c.ProveedorId,t.TipoDescripcion,c.CompraAsociado as Asociado,CompraOBS,CompraTipoSunat as TipoSunat
from Compras c
inner join Proveedor p
on p.ProveedorId=c.ProveedorId
inner join Compania co
on co.CompaniaId=c.CompaniaId
inner join TipoComprobante t
on t.TipoCodigo=c.TipoCodigo
where (c.TipoCodigo='07' or c.TipoCodigo='101') and(Convert(char(10),c.CompraComputo, 103) BETWEEN @f1 AND @f2)
order by c.CompraId desc
end
GO
/****** Object:  StoredProcedure [dbo].[listaNotaComE]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listaNotaComE] @f1 date,@f2 date
as
begin
select c.CompraId,c.CompraCorrelativo,c.CompaniaId,c.CompraRegistro,Convert(char(10),c.CompraComputo,103)as CompraComputo,Convert(char(10),c.CompraEmision,103)as CompraEmision,p.ProveedorRazon,
p.ProveedorRuc,c.TipoCodigo,c.CompraSerie,c.CompraNumero,c.CompraCondicion,c.CompraMoneda,CompraTipoCambio,c.CompraDias,Convert(char(10),c.CompraFechaPago,103) as CompraFechaPago,
c.CompraTipoIgv,CONVERT(VarChar(50), cast(c.CompraValorVenta as money ), 1) as ValorVenta,CONVERT(VarChar(50), cast(c.CompraDescuento as money ), 1)as Descuento,CONVERT(VarChar(50), 
cast(c.CompraSubtotal as money ), 1) as Subtotal,CONVERT(VarChar(50), cast(c.CompraIgv as money ), 1) as Igv,CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1) as Total,
CONVERT(VarChar(50), cast(c.compraSaldo as money ), 1) as CompraSaldo,c.CompraUsuario,co.CompaniaRazonSocial,
c.CompraEstado,c.ProveedorId,t.TipoDescripcion,c.CompraAsociado as Asociado,CompraOBS,CompraTipoSunat as TipoSunat
from Compras c
inner join Proveedor p
on p.ProveedorId=c.ProveedorId
inner join Compania co
on co.CompaniaId=c.CompaniaId
inner join TipoComprobante t
on t.TipoCodigo=c.TipoCodigo
where (c.TipoCodigo='07' or c.TipoCodigo='101') and(Convert(char(10),c.CompraEmision,103) BETWEEN @f1 AND @f2)
order by c.CompraId desc
end
GO
/****** Object:  StoredProcedure [dbo].[listaNotaCompra]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listaNotaCompra] 
as
begin
select c.CompraId,c.CompraCorrelativo,c.CompaniaId,c.CompraRegistro,Convert(char(10),c.CompraComputo,103)as CompraComputo,Convert(char(10),c.CompraEmision,103)as CompraEmision,p.ProveedorRazon,
p.ProveedorRuc,c.TipoCodigo,c.CompraSerie,c.CompraNumero,c.CompraCondicion,c.CompraMoneda,CompraTipoCambio,c.CompraDias,Convert(char(10),c.CompraFechaPago,103) as CompraFechaPago,
c.CompraTipoIgv,CONVERT(VarChar(50), cast(c.CompraValorVenta as money ), 1) as ValorVenta,CONVERT(VarChar(50), cast(c.CompraDescuento as money ), 1)as Descuento,CONVERT(VarChar(50), 
cast(c.CompraSubtotal as money ), 1) as Subtotal,CONVERT(VarChar(50), cast(c.CompraIgv as money ), 1) as Igv,CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1) as Total,
CONVERT(VarChar(50), cast(c.compraSaldo as money ), 1) as CompraSaldo,c.CompraUsuario,co.CompaniaRazonSocial,
c.CompraEstado,c.ProveedorId,t.TipoDescripcion,c.CompraAsociado as Asociado,CompraOBS,CompraTipoSunat as TipoSunat
from Compras c
inner join Proveedor p
on p.ProveedorId=c.ProveedorId
inner join Compania co
on co.CompaniaId=c.CompaniaId
inner join TipoComprobante t
on t.TipoCodigo=c.TipoCodigo
where (c.TipoCodigo='07' or c.TipoCodigo='101')and(Month(c.CompraComputo)=Month(GETDATE()) and year(c.CompraComputo)=year(GETDATE()))
order by c.CompraId desc
end
GO
/****** Object:  StoredProcedure [dbo].[listaPedidosFecha]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listaPedidosFecha] @fechainicio date,@fechafin date
as
begin
select n.NotaId,n.NotaDocu,n.NotaFecha,n.ClienteId,c.ClienteRazon,c.ClienteRuc,c.ClienteDni,
n.NotaCondicion,n.NotaFormaPago,n.NotaDias,(Convert(char(10),n.NotaFechaPago,103))as NotaFechaPago
,CONVERT(VarChar(50), cast(n.NotaSubtotal as money ), 1)as NotaSubtotal,n.NotaMovilidad,
n.NotaDescuento,CONVERT(VarChar(50), cast(n.NotaTotal as money ), 1)as OpGravada,
n.NotaAcuenta,CONVERT(VarChar(50), cast(n.NotaSaldo as money ), 1)as SaldoDocumento,
CONVERT(VarChar(50), cast(n.NotaAdicional as money ), 1)as NotaAdicional,CONVERT(VarChar(50), cast(n.NotaTarjeta as money ), 1)as TotalTarjeta,
CONVERT(VarChar(50), cast(n.NotaPagar as money ), 1)as TotalPagar,n.NotaUsuario,n.NotaEstado,
co.CompaniaRazonSocial as compania,c.ClienteDireccion as Direccion,n.NotaDireccion,n.NotaTelefono,n.NotaEntrega as Entrega,
n.ModificadoPor,n.FechaEdita,n.NotaConcepto,NotaSerie,NotaNumero,NotaEfectivo,NotaVuelto
from NotaPedido n
inner join Cliente c
on c.ClienteId=n.ClienteId
inner join Compania co
on co.CompaniaId=n.CompaniaId
where (Convert(char(10),n.NotaFecha,103) BETWEEN @fechainicio AND @fechafin)
order by 1 desc
end
GO
/****** Object:  StoredProcedure [dbo].[listaProveedor]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listaProveedor]
 as
 begin
 select
 'Codigo|RazonSocial|RUC|Contacto|Celular|Telefono|Correo|Direccion|Estado¬90|400|105|200|150|150|150|250|100¬String|String|String|String|String|String|String|String|String¬'+
 isnull((select stuff((SELECT '¬'+ CONVERT(varchar,p.ProveedorId)+'|'+p.ProveedorRazon+'|'+p.ProveedorRuc+'|'+
 p.ProveedorContacto+'|'+p.ProveedorCelular+'|'+p.ProveedorTelefono+'|'+p.ProveedorCorreo+'|'+
 p.ProveedorDireccion+'|'+p.ProveedorEstado
 from Proveedor p
 order by p.ProveedorId desc
 for xml path('')),1,1,'')),'~')
 end
GO
/****** Object:  StoredProcedure [dbo].[listarCaja]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listarCaja]
as
begin
select c.CajaId,c.CajaFecha,c.CajaCierre,
CONVERT(VarChar(50), cast(c.MontoIniSOl as money ), 1)as MontoIniSol,
CONVERT(VarChar(50), cast(c.CajaIngresos as money ), 1)as CajaIngresos,
CONVERT(VarChar(50), cast(c.CajaDeposito as money ), 1)as CajaDeposito,
CONVERT(VarChar(50), cast(c.CajaSalidas as money ), 1)as  CajaSalidas,
CONVERT(VarChar(50), cast(c.CajaTotal as money ), 1)as  CajaTotal,
c.CajaEncargado,c.CajaUsuario,c.CajaEstado
from Caja c
where Month(c.CajaFecha)=Month(GETDATE()) and year(c.CajaFecha)=year(GETDATE())
order by 2 desc
end
GO
/****** Object:  StoredProcedure [dbo].[listarCajaFecha]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listarCajaFecha]
@fechainicio date,
@fechafin date
as
begin
select c.CajaId,c.CajaFecha,c.CajaCierre,
CONVERT(VarChar(50), cast(c.MontoIniSOl as money ), 1)as MontoIniSol,
CONVERT(VarChar(50), cast(c.CajaIngresos as money ), 1)as CajaIngresos,
CONVERT(VarChar(50), cast(c.CajaDeposito as money ), 1)as CajaDeposito,
CONVERT(VarChar(50), cast(c.CajaSalidas as money ), 1)as  CajaSalidas,
CONVERT(VarChar(50), cast(c.CajaTotal as money ), 1)as  CajaTotal,
c.CajaEncargado,c.CajaUsuario,c.CajaEstado
from Caja c
where (Convert(char(10),c.CajaFecha,103) BETWEEN @fechainicio AND @fechafin)
order by 2 desc
end
GO
/****** Object:  StoredProcedure [dbo].[listarClienteB]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listarClienteB]
as
begin
select 
'ClienteId|RazonSocial|RUC|DNI|Direccion|Celular|Telefono|Correo|Fecha|Usuario|Estado|Direc¬90|420|95|75|290|110|110|100|150|150|100|90¬String|String|String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select stuff((SELECT '¬'+ convert(varchar,c.ClienteId)+'|'+c.ClienteRazon+'|'+isnull(c.ClienteRuc,'')+'|'+
isnull(c.ClienteDni,'')+'|'+isnull(c.ClienteDespacho,'')+'|'+isnull(c.ClienteMovil,'')+'|'+
isnull(c.ClienteTelefono,'')+'|'+isnull(c.ClienteCorreo,'')+'|'+
(IsNull(convert(varchar,c.clienteFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,c.clienteFecha,114),1,8),''))+'|'+
c.ClienteUsuario+'|'+isnull(c.ClienteEstado,'')+'|'+isnull(c.ClienteDireccion,'')
FROM Cliente c
order by c.ClienteId desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[listarCompras]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listarCompras] 
as
begin
select c.CompraId,c.CompraCorrelativo,c.CompaniaId,c.CompraRegistro,Convert(char(10),c.CompraComputo,103)as CompraComputo,Convert(char(10),c.CompraEmision,103)as CompraEmision,p.ProveedorRazon,
p.ProveedorRuc,c.TipoCodigo,c.CompraSerie,c.CompraNumero,c.CompraCondicion,c.CompraMoneda,CompraTipoCambio,c.CompraDias,Convert(char(10),c.CompraFechaPago,103) as CompraFechaPago,
c.CompraTipoIgv,CONVERT(VarChar(50), cast(c.CompraValorVenta as money ), 1) as ValorVenta,CONVERT(VarChar(50), cast(c.CompraDescuento as money ), 1)as Descuento,CONVERT(VarChar(50), 
cast(c.CompraSubtotal as money ), 1) as Subtotal,CONVERT(VarChar(50), cast(c.CompraIgv as money ), 1) as Igv,CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1) as Total,
CONVERT(VarChar(50), cast(c.compraSaldo as money ), 1) as CompraSaldo,c.CompraUsuario,co.CompaniaRazonSocial,
c.CompraEstado,c.ProveedorId,t.TipoDescripcion,c.CompraAsociado as Asociado,CompraOBS,CompraTipoSunat as TipoSunat,CompraConcepto as Concepto,
c.CompraPercepcion as Percepcion
from Compras c
inner join Proveedor p
on p.ProveedorId=c.ProveedorId
inner join Compania co
on co.CompaniaId=c.CompaniaId
inner join TipoComprobante t
on t.TipoCodigo=c.TipoCodigo
where (c.TipoCodigo<>'07' and c.TipoCodigo<>'101') and(Month(c.CompraComputo)=Month(GETDATE()) and year(c.CompraComputo)=year(GETDATE()))
order by c.CompraId desc
end
GO
/****** Object:  StoredProcedure [dbo].[listarDetaCaja]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listarDetaCaja]
@CajaId numeric(38)
as
begin
Declare @Movilidad decimal(18,2)
set @Movilidad=isnull((select SUM(NotaMovilidad)from NotaPedido
where CajaId=@CajaId),0)
select
'DetalleId|CajaId|Fecha|NroNota|Movimiento|Referencia|Concepto|Moneda|TipoCambio|Efectivo|Monto|Vuelto|DetalleEfectivo|Entrega¬100|100|145|85|100|100|250|80|100|95|95|95|100|118¬String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select stuff((select '¬'+
convert(varchar,d.DetalleId)+'|'+convert(varchar,d.CajaId)+'|'+
(IsNull(convert(varchar,d.DetalleFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,d.DetalleFecha,114),1,8),''))+'|'+
convert(varchar,d.NotaId)+'|'+d.DetalleMovimiento+'|'+d.DetalleReferencia+'|'+d.DetalleConcepto+'|'+d.DetalleMoneda+'|'+convert(varchar,d.DetalleTipoCambio)+'|'+
CONVERT(VarChar(50), cast(d.DetalleEfectivo as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DetalleMonto as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DetalleVuelto as money ), 1)+'|'+
convert(varchar,d.DetalleEfectivo)+'|'+ISNULL(n.NotaEntrega,'INMEDIATA')
from CajaDetalle d
left join NotaPedido n
on n.NotaId=d.NotaId
where d.CajaId=@CajaId
order by d.DetalleId desc
for xml path('')),1,1,'')),'~')+'['+ 
'Codigo|Descripcion|Cantidad|UM|Importe¬120|390|100|85|100¬String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+p.ProductoCodigo+'|'+
d.DetalleDescripcion+'|'+
CONVERT(VarChar(50), cast(SUM(d.DetalleCantidad) as money ), 1)+'|'+d.DetalleUm+'|'+
CONVERT(VarChar(50), cast(SUM(d.DetalleImporte) as money ), 1)
from NotaPedido n
inner join DetallePedido d
on d.NotaId=n.NotaId
inner join Producto p
on p.IdProducto=d.IdProducto
where CajaId=@CajaId and(n.NotaEstado='CANCELADO' and n.NotaConcepto='MERCADERIA') 
group by p.ProductoCodigo,d.DetalleDescripcion,d.DetalleUm
order by d.DetalleDescripcion asc
for xml path('')),1,1,'')),'~')+'['+
CONVERT(VarChar(50), cast(@Movilidad as money ), 1)
end
GO
/****** Object:  StoredProcedure [dbo].[listarDetaLetra]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listarDetaLetra] @LetraId numeric(38)
as
begin
select d.DetalleId,d.LetraId,d.LetraCanje,d.LetraDias,(Convert(char(10),d.LetraVencimiento,103)) as Vencimeinto,
CONVERT(VarChar(50), cast(d.DetalleSaldo as money ), 1) as SaldoLetra,
CONVERT(VarChar(50), cast(d.DetalleMonto as money ), 1) as DetalleMonto,d.DetalleEstado
from DetalleLetra d
where d.LetraId=@LetraId 
order by 1 asc
end
GO
/****** Object:  StoredProcedure [dbo].[listarDetaliquida]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listarDetaliquida] @LiquidacionId numeric(38)
as
begin
select d.DetalleId,d.LiquidacionId,d.CompraId,d.Numero as Numero,
d.Proveedor,CONVERT(VarChar(50), cast(d.SaldoDocu as money ), 1) as Saldo,d.Moneda,d.EfectivoSoles,
d.EfectivoDolar,d.DepositoSoles,d.DepositoDolar,d.TipoCambio,d.EntidadBanco,d.NroOperacion,
CONVERT(VarChar(50), cast(d.AcuentaGeneral as money ), 1) as Acuenta,
d.FechaPago,CONVERT(VarChar(50), cast(d.SaldoActual as money ), 1)as SaldoActual,d.Concepto
from DetalleLiquida d
where d.LiquidacionId=@LiquidacionId
order by 1 asc
end
GO
/****** Object:  StoredProcedure [dbo].[listaReporteCaja]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaReporteCaja]
as
begin
select d.DetalleId,d.CajaId,(Convert(char(10),d.DetalleFecha,103))+' '+ substring(CONVERT(VarChar(50),d.DetalleFecha),12,17)as Fecha,d.NotaId as NroNota,d.DetalleMovimiento as Movimiento,
d.DetalleConcepto as Concepto,d.DetalleMoneda as Moneda,
CONVERT(VarChar(50), cast(d.DetalleMonto as money ), 1)as Monto,
(Convert(char(10),c.CajaFecha,103))+' '+ substring(CONVERT(VarChar(50),c.CajaFecha),12,17)as Apertura,c.CajaEncargado,CONVERT(VarChar(50), cast(c.MontoIniSOl as money ), 1)as MontoInicial,
c.CajaEstado,c.CajaUsuario as Usuario,c.CajaCierre as FechaCierre
from CajaDetalle d
inner join Caja c
on c.CajaId=d.CajaId
order by 1 desc
end
GO
/****** Object:  StoredProcedure [dbo].[listaReporteCajaB]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaReporteCajaB]@CajaId numeric(38)
as
begin
select d.DetalleId,d.CajaId,(Convert(char(10),d.DetalleFecha,103))+' '+ substring(CONVERT(VarChar(50),d.DetalleFecha),12,17)as Fecha,d.NotaId as NroNota,d.DetalleMovimiento as Movimiento,
d.DetalleConcepto as Concepto,d.DetalleMoneda as Moneda,
CONVERT(VarChar(50), cast(d.DetalleMonto as money ), 1)as Monto,
(Convert(char(10),c.CajaFecha,103))+' '+ substring(CONVERT(VarChar(50),c.CajaFecha),12,17)as Apertura,c.CajaEncargado,CONVERT(VarChar(50), cast(c.MontoIniSOl as money ), 1)as MontoInicial,
c.CajaEstado,c.CajaUsuario as Usuario,c.CajaCierre as FechaCierre
from CajaDetalle d
inner join Caja c
on c.CajaId=d.CajaId
where d.CajaId=@CajaId
order by 1 desc
end
GO
/****** Object:  StoredProcedure [dbo].[listarGuia]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listarGuia] 
@Concepto varchar(60)
as
begin
select g.GuiaId,g.GuiaNumero,g.GuiaMotivo,g.GuiaRegistro,g.GuiaFechaTraslado,
g.GuiaDestinatario,g.GuiaRucDes,g.GuiaAlmacen,g.GuiaPartida,g.GuiaLLegada,g.GuiaTramsporte,g.GuiaTransporteRuc,g.GuiaChofer,
g.GuiaPlaca,g.GuiaConstancia,g.GuiaLicencia,g.GuiaUsuario,CONVERT(VarChar(50),cast(g.GuiaTotal as money ), 1) as Total,g.GuiaConcepto as Concepto,
g.ClienteId,g.GuiaEstado,g.GuiaTelefono as Telefono
from GuiaRemision g
where g.GuiaConcepto=@Concepto and (Month(g.GuiaRegistro)=Month(GETDATE()) and YEAR(g.GuiaRegistro)=YEAR(GETDATE()))
order by 1 desc
end
GO
/****** Object:  StoredProcedure [dbo].[listarGuiaFecha]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listarGuiaFecha]  @fechainicio date,@fechafin date,@Concepto varchar(60)
as
begin
select g.GuiaId,g.GuiaNumero,g.GuiaMotivo,g.GuiaRegistro,g.GuiaFechaTraslado,
g.GuiaDestinatario,g.GuiaRucDes,g.GuiaAlmacen,g.GuiaPartida,g.GuiaLLegada,g.GuiaTramsporte,g.GuiaTransporteRuc,g.GuiaChofer,
g.GuiaPlaca,g.GuiaConstancia,g.GuiaLicencia,g.GuiaUsuario,CONVERT(VarChar(50),cast(g.GuiaTotal as money ), 1) as Total,g.GuiaConcepto as Concepto,
g.ClienteId,g.GuiaEstado
from GuiaRemision g
where (Convert(char(10),g.GuiaFechaTraslado,103) BETWEEN @fechainicio AND @fechafin) and g.GuiaConcepto=@Concepto
order by 1 desc
end
GO
/****** Object:  StoredProcedure [dbo].[listarKardex]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listarKardex] 
@IdProducto numeric(20)
as
begin
	select 
	'KardexId|IdProducto|FechaMovimiento|Motivo|Documento|StockInicial|CantidadIngre|CantidadSali|PrecioCosto|StockFinal|Concepto|Responsable¬100|100|145|150|145|115|115|115|115|115|100|160¬String|String|String|String|String|String|String|String|String|String|String|String¬'+
	isnull((select STUFF ((select '¬'+convert(varchar,k.KardexId)+'|'+CONVERT(varchar,k.IdProducto)+'|'+
	(IsNull(convert(varchar,k.KardexFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,k.KardexFecha,114),1,8),''))+'|'+
	k.KardexMotivo+'|'+k.KardexDocumento+'|'+
	CONVERT(VarChar(50), cast(k.StockInicial as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(k.CantidadIngreso as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(k.CantidadSalida as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(k.PrecioCosto as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(k.StockFinal as money ), 1)+'|'+
	K.KadexConcepto+'|'+k.Usuario
	from Kardex k with(nolock)
	where k.IdProducto=@IdProducto and (Month(k.KardexFecha)=Month(GETDATE()) and YEAR(k.kardexFecha)=year(getdate()))
	order by k.KardexId desc
	for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[listarKardexFecha]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listarKardexFecha] 
@Id numeric(20),
@fechainicio date,@fechafin date
as
begin
select 
	'KardexId|IdProducto|FechaMovimiento|Motivo|Documento|StockInicial|CantidadIngre|CantidadSali|PrecioCosto|StockFinal|Concepto|Responsable¬100|100|145|150|145|115|115|115|115|115|100|160¬String|String|String|String|String|String|String|String|String|String|String|String¬'+
	isnull((select STUFF ((select '¬'+convert(varchar,k.KardexId)+'|'+CONVERT(varchar,k.IdProducto)+'|'+
	(IsNull(convert(varchar,k.KardexFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,k.KardexFecha,114),1,8),''))+'|'+
	k.KardexMotivo+'|'+k.KardexDocumento+'|'+
	CONVERT(VarChar(50), cast(k.StockInicial as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(k.CantidadIngreso as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(k.CantidadSalida as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(k.PrecioCosto as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(k.StockFinal as money ), 1)+'|'+
	K.KadexConcepto+'|'+k.Usuario
	from Kardex k
	where k.IdProducto=@Id and (Convert(char(10),k.KardexFecha,103) BETWEEN @fechainicio AND @fechafin)
	order by k.KardexId desc
    for xml path('')),1,1,'')),'~')
order by 1 desc
end
GO
/****** Object:  StoredProcedure [dbo].[listarLetraFecha]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listarLetraFecha] @fechainicio date,@fechafin date
as
begin
select l.LetraId, l.ProveedorId,p.ProveedorRazon,l.LetraFechaReg,(Convert(char(10),l.LetraFechaGiro,103)) as FechaGiro,
l.LetraMoneda as Moneda,CONVERT(VarChar(50), cast(l.LetraSaldo as money ), 1)as SaldoLetras,CONVERT(VarChar(50), cast(l.LetraTotal as money ), 1)as TotalLetras,l.LetraUsuario,l.LetraEstado as Estado
from Letra l
inner join Proveedor p
on p.ProveedorId=l.ProveedorId
where (Convert(char(10),l.LetraFechaGiro,103) BETWEEN @fechainicio AND @fechafin)
order by 1 desc
end
GO
/****** Object:  StoredProcedure [dbo].[listarLetras]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listarLetras]
as
begin
select l.LetraId, l.ProveedorId,p.ProveedorRazon,l.LetraFechaReg,(Convert(char(10),l.LetraFechaGiro,103)) as FechaGiro,l.LetraMoneda as Moneda,
CONVERT(VarChar(50), cast(l.LetraSaldo as money ), 1)as SaldoLetras,CONVERT(VarChar(50), cast(l.LetraTotal as money ), 1)as TotalLetras,
l.LetraUsuario,l.LetraEstado as Estado,l.CompaniaId
from Letra l
inner join Proveedor p
on p.ProveedorId=l.ProveedorId
where year(LetraFechaGiro)=YEAR(GETDATE())
order by 1 desc
end
GO
/****** Object:  StoredProcedure [dbo].[listarPedidos]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listarPedidos]
as
begin
(select n.NotaId,n.NotaDocu,n.NotaFecha,n.ClienteId,c.ClienteRazon,c.ClienteRuc,c.ClienteDni,
n.NotaCondicion,n.NotaFormaPago,n.NotaDias,(Convert(char(10),n.NotaFechaPago,103))as NotaFechaPago
,CONVERT(VarChar(50), cast(n.NotaSubtotal as money ), 1)as NotaSubtotal,n.NotaMovilidad,
n.NotaDescuento,CONVERT(VarChar(50), cast(n.NotaTotal as money ), 1)as OpGravada,
n.NotaAcuenta,CONVERT(VarChar(50), cast(n.NotaSaldo as money ), 1)as SaldoDocumento,
CONVERT(VarChar(50), cast(n.NotaAdicional as money ), 1)as NotaAdicional,CONVERT(VarChar(50), cast(n.NotaTarjeta as money ), 1)as TotalTarjeta,
CONVERT(VarChar(50), cast(n.NotaPagar as money ), 1)as TotalPagar,n.NotaUsuario,n.NotaEstado,
co.CompaniaRazonSocial as compania,c.ClienteDireccion as Direccion,n.NotaDireccion,
n.NotaTelefono,n.NotaEntrega as Entrega,n.ModificadoPor,
n.FechaEdita,n.NotaConcepto,NotaSerie,NotaNumero,NotaEfectivo,NotaVuelto
from NotaPedido n with(nolock)			
inner join Cliente c
on c.ClienteId=n.ClienteId
inner join Compania co
on co.CompaniaId=n.CompaniaId
where(Day(n.NotaFecha)=Day(GETDATE()) and month(n.NotaFecha)=month(GETDATE())and year(n.NotaFecha)=year(GETDATE()))
)
union all
(select n.NotaId,n.NotaDocu,n.NotaFecha,n.ClienteId,c.ClienteRazon,c.ClienteRuc,c.ClienteDni,
n.NotaCondicion,n.NotaFormaPago,n.NotaDias,(Convert(char(10),n.NotaFechaPago,103))as NotaFechaPago
,CONVERT(VarChar(50), cast(n.NotaSubtotal as money ), 1)as NotaSubtotal,n.NotaMovilidad,
n.NotaDescuento,CONVERT(VarChar(50), cast(n.NotaTotal as money ), 1)as OpGravada,
n.NotaAcuenta,CONVERT(VarChar(50), cast(n.NotaSaldo as money ), 1)as SaldoDocumento,
CONVERT(VarChar(50), cast(n.NotaAdicional as money ), 1)as NotaAdicional,CONVERT(VarChar(50), cast(n.NotaTarjeta as money ), 1)as TotalTarjeta,
CONVERT(VarChar(50), cast(n.NotaPagar as money ), 1)as TotalPagar,n.NotaUsuario,n.NotaEstado,
co.CompaniaRazonSocial as compania,c.ClienteDireccion as Direccion,n.NotaDireccion,
n.NotaTelefono,n.NotaEntrega as Entrega,n.ModificadoPor,
n.FechaEdita,n.NotaConcepto,NotaSerie,NotaNumero,NotaEfectivo,NotaVuelto
from NotaPedido n with(nolock)
inner join Cliente c
on c.ClienteId=n.ClienteId
inner join Compania co
on co.CompaniaId=n.CompaniaId
where n.NotaEstado<>'ANULADO'and(n.NotaConcepto='MERCADERIA' and((n.NotaEstado<>'CANCELADO' and n.NotaDocu <>'PROFORMA')and convert(date,n.NotaFecha) < convert(date,getdate()))))
order by 1 desc
end
GO
/****** Object:  StoredProcedure [dbo].[listarPersonal]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listarPersonal]
as
begin
SELECT p.PersonalId,p.PersonalCodigo,p.PersonalNombres,p.PersonalApellidos,
p.PersonalApellidos+' '+p.PersonalNombres as Nombres,a.AreaNombre, 
p.PersonalDNI,p.PersonalRuc,p.PersonalTelefono,p.PersonalTelefonoAsi,p.PersonalIngreso,
p.PersonalBajaFecha,Convert(char(10),p.PersonalNacimiento,103) as PersonalNacimiento,
(select dbo.CalcularEdad(p.personalNacimiento))AS Edad,p.PersonalDireccion,
p.PersonalSueldo,p.PersonalEmail,c.CompaniaRazonSocial,p.PersonalEstado,p.PersonalImagen,
p.HoraIngreso as Hora
FROM Personal p 
INNER JOIN Area a 
ON a.AreaId =p.AreaId
inner join Compania c
on c.CompaniaId=p.CompaniaId
order by p.PersonalApellidos asc
end
GO
/****** Object:  StoredProcedure [dbo].[listarProducto]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listarProducto]
as
begin
SELECT p.IdProducto as ID,s.NombreSublinea as Categoria,p.ProductoCodigo as Codigo,
p.ProductoNombre as Descripcion,p.ProductoCantidad as Cantidad, 
p.ProductoUM as UM,p.ProductoVenta as PrecioVenta,p.ProductoVentaB as PrecioVentaB,
convert(decimal(18,2),p.ProductoCosto) as PrecioCosto,
p.ProductoEstado as Estado,p.ProductoUsuario as Usuario,p.ProductoFecha as FechaEdicion,p.ProductoImagen,
(convert(varchar(60),cast((p.ProductoCantidad * p.ProductoCosto) as money),1))as Inversion,
(convert(varchar(60),cast((p.ProductoCantidad *p.ProductoVenta) as money),1))as VentaNeta,
(convert(varchar(60),cast(((p.ProductoCantidad *p.ProductoVenta)-(p.ProductoCantidad * p.ProductoCosto)) as money),1))as MargenUtilidad,
p.ValorCritico
FROM Producto p with(nolock)
INNER JOIN Sublinea s
ON p.IdSubLinea =s.IdSubLinea 
where p.ProductoEstado='BUENO'
order by p.IdProducto desc
end
GO
/****** Object:  StoredProcedure [dbo].[listarRenta]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listarRenta]
as
begin
select 
'ID|Compania|Anno|Mes|Declaracion|Igv|Renta|SaldoIgv|SaldoRenta|InteresIgv|InteresRenta|TotalIgv|TotalRenta|FormaPago|FechaPago|Entidad|NroOperacion|PagoTotal¬
80|90|80|80|145|120|120|120|120|120|120|120|110|70|120|100|100|120¬String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+convert(varchar,r.RentaId)+'|'+convert(varchar,r.CompaniaId)+'|'+convert(varchar,r.RentaANNO)+'|'+
convert(varchar,r.RentaMes)+'|'+dbo.MesNombre(r.RentaMes)+' '+convert(varchar,r.RentaANNO)+'|'+
CONVERT(VarChar(50), cast((r.IGV) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.Renta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.SaldoIGV) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.SaldoRenta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.InteresIgv) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.InteresRenta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.TributoIgv) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.TributoRenta) as money ), 1)+'|'+
CONVERT(char(1),r.FormaPago)+'|'+convert(varchar,r.FechaCancelacion,103)+'|'+r.EntidadBancaria+'|'+r.NroOperacion+'|'+
CONVERT(VarChar(50), cast((r.PagoTotal) as money ), 1)
from RentaMensual r
where year(r.FechaCancelacion)=year(getdate())
order by r.RentaId desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[listarRentaFecha]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listarRentaFecha] 
@fechainicio date,@fechafin date
as
begin
select 
'ID|Compania|Anno|Mes|Declaracion|Igv|Renta|SaldoIgv|SaldoRenta|InteresIgv|InteresRenta|TotalIgv|TotalRenta|FormaPago|FechaPago|Entidad|NroOperacion|PagoTotal¬
80|90|80|80|145|120|120|120|120|120|120|120|110|70|120|100|100|120¬String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+convert(varchar,r.RentaId)+'|'+convert(varchar,r.CompaniaId)+'|'+convert(varchar,r.RentaANNO)+'|'+
convert(varchar,r.RentaMes)+'|'+dbo.MesNombre(r.RentaMes)+' '+convert(varchar,r.RentaANNO)+'|'+
CONVERT(VarChar(50), cast((r.IGV) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.Renta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.SaldoIGV) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.SaldoRenta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.InteresIgv) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.InteresRenta) as money ), 1)+'|'+
CONVERT(VarChar(50), cast((r.TributoIgv) as money ), 1)+'|'+CONVERT(VarChar(50), cast((r.TributoRenta) as money ), 1)+'|'+
CONVERT(char(1),r.FormaPago)+'|'+convert(varchar,r.FechaCancelacion,103)+'|'+r.EntidadBancaria+'|'+r.NroOperacion+'|'+
CONVERT(VarChar(50), cast((r.PagoTotal) as money ), 1)
from RentaMensual r
where (Convert(char(10),r.FechaCancelacion,103) BETWEEN @fechainicio AND @fechafin)
order by r.RentaMes desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[listarSaldos]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listarSaldos] 
@ClienteId numeric(20)
as
begin
select
'DetalleId|NroNota|Idproducto|Codigo|Descripcion|Cantidad|Saldo|UM|Stock|UnidadM|CantInicial|critico|ClienteId|PrecioVenta|valorUM¬100|90|100|100|450|100|100|90|100|100|100|100|100|100|100¬String|String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF ((select '¬'+convert(varchar,d.DetalleId)+'|'+convert(varchar,d.NotaId)+'|'+
convert(varchar,d.IdProducto)+'|'+p.ProductoCodigo+'|'+d.DetalleDescripcion+'|'+''+'|'+
convert(varchar(50),cast(d.CantidadSaldo as money),1)+'|'+d.DetalleUm+'|'+
convert(varchar(50),cast(p.ProductoCantidad as money),1)+'|'+p.ProductoUM+'|'+
convert(varchar(50),cast(d.DetalleCantidad as money),1)+'|'+
convert(varchar,p.ValorCritico)+'|'+convert(varchar,n.ClienteId)+'|'+
convert(varchar,d.DetallePrecio)+'|'+convert(varchar,d.ValorUM)
from DetallePedido d
inner join NotaPedido n
on n.NotaId=d.NotaId
inner join Producto p
on p.IdProducto=d.IdProducto
where n.ClienteId=@ClienteId and d.cantidadSaldo>0
order by n.NotaId desc,d.DetalleId asc
for xml path('')),1,1,'')),'~')+'_'+
isnull((select STUFF ((select '¬' +CONVERT(VarChar(50), cast(sum(n.NotaSaldo) as money ), 1)
from NotaPedido n
where n.ClienteId=@ClienteId and n.NotaEntrega='POR ENTREGAR'
for xml path('')),1,1,'')),'0')
end
GO
/****** Object:  StoredProcedure [dbo].[listarSaldosB]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listarSaldosB] @NotaId numeric(38)
as
begin
select d.DetalleId,d.NotaId,d.IdProducto,p.ProductoCodigo as Codigo,d.DetalleDescripcion as Descripcion,
d.CantidadSaldo as CantidadSaldo,p.ProductoCantidad as Stock,substring(p.ProductoUM,1,3) as UM,d.DetalleCantidad as CantidadInicial,
p.ValorCritico,n.ClienteId,d.DetallePrecio as PrecioCosto
from DetallePedido d
inner join NotaPedido n
on n.NotaId=d.NotaId
inner join Producto p
on p.IdProducto=d.IdProducto
where d.NotaId=@NotaId and d.cantidadSaldo>0
order by 1 asc
end
GO
/****** Object:  StoredProcedure [dbo].[listarSublinea]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listarSublinea]
as
begin
select s.IdSubLinea,s.NombreSublinea,s.CodigoSunat,l.NombreLinea,s.EnviarIMP
from Sublinea s
inner join Linea l
on l.IdLinea=s.IdLinea
order by s.NombreSublinea asc
end
GO
/****** Object:  StoredProcedure [dbo].[listarUM]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[listarUM] 
@IdProducto numeric(20)
as
begin
select
'IdUm|IdProducto|UNIDAD M|Valor|PreVenta|PreVentaB|PreCosto¬80|80|110|100|100|100|100¬String|String|String|Decimal|String|String|String¬'+
isnull((select STUFF ((select '¬'+convert(varchar,m.IdUm)+'|'+CONVERT(varchar,m.IdProducto)+'|'+m.UMDescripcion+'|'+
convert(varchar,m.ValorUM)+'|'+CONVERT(VarChar(50),cast(m.PrecioVenta as money ), 1)+'|'+CONVERT(VarChar(50), cast(m.PrecioVentaB as money ), 1)+'|'+
CONVERT(varchar(50),m.PrecioCosto)
from UnidadMedida m
where m.IdProducto=@IdProducto
order by m.ValorUM asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[listarUsuario]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listarUsuario]
as
begin
select u.UsuarioID,p.PersonalId,(((SUBSTRING(p.PersonalNombres+' ',1,CHARINDEX(' ',p.PersonalNombres+' ')-1))))+' '+ p.PersonalApellidos as Personal,u.UsuarioAlias,dbo.desincrectar(u.UsuarioClave)as UsuarioClave,a.AreaNombre,u.UsuarioFechaReg,u.Usuarioestado
from Usuarios u
inner join Personal p
on p.PersonalId=u.PersonalId
inner join Area a
on a.AreaId=p.AreaId
order by u.UsuarioID desc
end
GO
/****** Object:  StoredProcedure [dbo].[listaTempoCompra]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaTempoCompra]
@UsuarioID int
as
begin
select
'Id|IdProducto|Codigo|Descripcion|UM|Cantidad|PrecioCosto|Descuento|Importe|ValorUM|Estado¬100|100|100|420|80|90|100|100|110|100|100¬String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF ((select '¬'+convert(varchar,t.TemporalId)+'|'+convert(varchar,t.IdProducto)+'|'+
t.DetalleCodigo+'|'+t.Descripcion+'|'+t.DetalleUM+'|'+
CONVERT(VarChar(50),cast(t.DetalleCantidad as money ), 1)+'|'+
convert(varchar,t.PrecioCosto)+'|'+convert(varchar,t.DetalleDescuento)
+'|'+convert(varchar,t.DetalleImporte)+'|'+CONVERT(varchar,t.ValorUM)+'|'+
t.DetalleEstado
from TemporalCompra t 
inner join Producto p 
on p.IdProducto=t.IdProducto 
where t.UsuarioID=@UsuarioID
order by t.TemporalId asc
for xml path('')),1,1,'')),'~')+'['+
'IdUm|IdProducto|UnidadM|Valor|Costo¬100|100|100|100|100¬String|String|String|String|String¬'+
isnull((select STUFF ((select '¬'+convert(varchar,u.IdUm)+'|'+convert(varchar,u.IdProducto)+'|'+
u.UMDescripcion+'|'+CONVERT(VarChar(50), cast(u.ValorUM as money ), 1)+'|'+
convert(varchar,t.PrecioCosto)
from UnidadMedida u
inner join TemporalCompra t
on t.IdProducto=u.IdProducto
where t.UsuarioID=@UsuarioID
order by u.ValorUM asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[listaTempoLiquida]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaTempoLiquida] @UsuarioId Int
as
begin
select t.TemporalId,t.IdDeuda,t.Numero,t.Proveedor,
CONVERT(VarChar(50), cast(t.SaldoDocu as money ), 1) as CompraSaldo,t.Moneda,t.TipoCambio,t.EfectivoSoles,t.EfectivoDolar,t.DepositoSoles,t.DepositoDolar,t.EntidadBanco,
t.NroOperacion,CONVERT(VarChar(50), cast(t.AcuentaGeneral as money ), 1) as AcuentaGeneral,
t.UsuarioId,t.TemporalFecha,CONVERT(VarChar(50), cast(t.SaldoDocu - t.AcuentaGeneral as money ), 1) as SaldoActual,t.Concepto
from TemporalLiquida t
where UsuarioId=@UsuarioId
order by 1 asc
end
GO
/****** Object:  StoredProcedure [dbo].[listaTempoLiVenta]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaTempoLiVenta] @UsuarioId Int
as
begin
select t.TemporalId,t.DocuId,
case when n.NotaDocu='PROFORMA V' then
substring(n.NotaDocu,1,1)+'V '+convert(varchar,n.NotaId)
else substring(n.NotaDocu,1,1)+'V '+n.NotaSerie+'-'+n.NotaNumero end Numero,
c.ClienteRazon,
CONVERT(VarChar(50), cast(t.SaldoDocu as money ), 1) as DocuSaldo,'SOLES' as Moneda,t.TipoCambio,
t.EfectivoSoles,t.EfectivoDolar,t.DepositoSoles,t.DepositoDolar,t.EntidadBanco,
t.NroOperacion,CONVERT(VarChar(50), cast(t.AcuentaGeneral as money ), 1) as AcuentaGeneral,
t.UsuarioId,t.TemporalFecha,CONVERT(VarChar(50), cast(t.SaldoDocu - t.AcuentaGeneral as money ), 1) as SaldoActual,t.NotaId
from TemporalLiVenta t
inner join NotaPedido n
on n.NotaId=t.NotaId
inner join Cliente c
on c.ClienteId=n.ClienteId
where t.UsuarioId=@UsuarioId
order by 1 asc
end
GO
/****** Object:  StoredProcedure [dbo].[listaTempoVenta]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[listaTempoVenta]
@UsuarioID int
	as
	select t.temporalId,t.UsuarioID,t.IdProducto,p.ProductoCodigo as Codigo,t.cantidad as Cantidad,
	t.UniMedida as UM,p.ProductoNombre as Descripcion,
	cast((p.ProductoCosto* t.ValorUM) as decimal(18,2)) as ProductoCosto,t.precioventa,t.importe,p.ProductoImagen as Imagen,
	t.ValorUM,convert(decimal(18,2),t.precioventa/1.18) as PrecioSunat,
	(t.importe - convert(decimal(18,2),t.importe/1.18)) as IGVPrecio,
	convert(decimal(18,2),t.importe/1.18)as ImporteSunat
	from TemporalVenta t
	inner join Producto p
	on p.IdProducto=t.IdProducto
	where t.UsuarioID=@UsuarioID 
	order by t.temporalId asc
GO
/****** Object:  StoredProcedure [dbo].[listaTempoVentaB]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listaTempoVentaB]     
@Data varchar(max)      
as      
Begin      
Declare @UsuarioID int,  
        @IGV decimal(18,2)     
Declare @p1 int,@p2 int     
Set @Data = LTRIM(RTrim(@Data))      
Set @p1 = CharIndex('|',@Data,0)   
Set @p2= Len(@Data)+1      
Set @UsuarioID=convert(int,SUBSTRING(@Data,1,@p1-1))      
Set @IGV=convert(decimal(18,3),SUBSTRING(@Data,@p1+1,@p2-@p1-1))  
  
Declare @IgvD decimal(18,3),@IgvR decimal(18,3)  
  
set @IgvR=(@IGV/100)  
set @IgvD=@IgvR+1  
  
select  
'TemporalId|UsuarioId|IdProducto|Codigo|Cantidad|UM|Descripcion|PrecioCosto|PrecioUni|Importe|Imagen|ValorUM|PrecioSunat|IGVPrecio|ImporteSunat¬100|100|100|100|100|100|100|100|100|100|100|100|100|100|100¬String|String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+    
 isnull((select STUFF ((select '¬'+convert(varchar,t.temporalId)+'|'+CONVERT(varchar,t.UsuarioId)+'|'+convert(varchar,t.IdProducto)+'|'+    
 p.ProductoCodigo+'|'+convert(varchar,t.cantidad)+'|'+t.UniMedida+'|'+p.ProductoNombre+'|'+    
 convert(varchar,cast((p.ProductoCosto* t.ValorUM) as decimal(18,2)))+'|'+    
 convert(varchar,t.precioventa)+'|'+    
 CONVERT(VarChar(50), cast(t.importe as money ), 1)+'|'+    
 p.ProductoImagen+'|'+    
 convert(varchar,t.ValorUM)+'|'+  
   
 convert(varchar,convert(decimal(18,6),t.precioventa/@IgvD))+'|'+    
 convert(varchar,(t.importe - convert(decimal(18,6),t.importe/@IgvD)))+'|'+    
 convert(varchar,convert(decimal(18,6),t.importe/@IgvD))    
   
 from TemporalVenta t    
 inner join Producto p    
 on p.IdProducto=t.IdProducto    
 where t.UsuarioID=@UsuarioID     
 order by t.temporalId asc    
 for xml path('')),1,1,'')),'~')  
   
 End  
 
GO
/****** Object:  StoredProcedure [dbo].[listaTipoCambio]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listaTipoCambio]
as
begin
select
'ID|Fecha|COMPRA|VENTA|EMPRESA¬90|110|108|108|117¬String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+ convert(varchar,t.IdTipo),+'|'+
(Convert(char(10),t.TipoFecha,103))+'|'+convert(varchar,t.TipoCompra)+'|'+
convert(varchar,t.TipoVenta)+'|'+
convert(varchar,t.TipoEmpresa) 
from TipoCambio t 
where MONTH(t.TipoFecha)=MONTH(GETDATE()) and YEAR(t.TipoFecha)=YEAR(GETDATE()) 
order by t.TipoFecha desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[LuisDuenas]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[LuisDuenas]
as
begin
select 'SubLinea|Codigo|Descipcion|Stock|UM|Costo¬295|130|470|105|105|105¬'+
isnull((select STUFF((select'¬'+s.NombreSublinea+'|'+p.ProductoCodigo+'|'+
p.ProductoNombre+'|'+
CONVERT(VarChar(50), cast(p.ProductoCantidad as money ), 1)+'|'+
p.ProductoUM+'|'+CONVERT(VarChar(50), cast(p.ProductoCosto as money ), 1)
from Producto p
inner join Sublinea s
on s.IdSubLinea=p.IdSubLinea
where p.ProductoCantidad < = p.ValorCritico
order by p.ProductoNombre asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[LuisDuenasB]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[LuisDuenasB] 
@fechainicio date,
@fechafin date
as
begin
select 'Fecha|Vendedor|Descripcion|UM|Cantidad|PrecioUni|Costo|GXUnidad|Ganancia¬130|150|400|65|110|110|110|110|115¬'+
(select STUFF((select '¬'+
(IsNull(convert(varchar,n.NotaFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,n.NotaFecha,114),1,8),''))
+'|'+n.NotaUsuario+'|'+
d.DetalleDescripcion+'|'+d.DetalleUm+'|'+
CONVERT(VarChar(50), cast((d.DetalleCantidad) as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DetallePrecio as money ), 1)+'|'+
CONVERT(VarChar(50), cast(d.DetalleCosto as money ), 1) +'|'+
CONVERT(VarChar(50), cast((d.DetallePrecio-d.DetalleCosto) as money ), 1)+'|'+
CONVERT(VarChar(50), cast(((d.DetallePrecio-d.DetalleCosto)* d.DetalleCantidad) as money ), 1)
	 from DetallePedido d (noLOCK) 
	 inner join NotaPedido n (noLOCK)
	 on n.NotaId=d.NotaId
	 where (Convert(char(10),n.NotaFecha,103) BETWEEN @fechainicio AND @fechafin)  
	 and n.NotaEstado='CANCELADO'
	 order by n.NotaFecha desc
	 for xml path('')),1,1,''))
 end
GO
/****** Object:  StoredProcedure [dbo].[MRDuenas]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[MRDuenas]
as
begin
select 'SubLineas|Productos['+
isnull((select STUFF((select '¬'+ convert(varchar,s.IdSubLinea)+'|'+s.NombreSublinea
from Sublinea s
for XMl path('')),1,1,'')),'~')+'['+
'Descripcion|Cantidad|UM|PreVenta|PreVentaB|PreCosto¬390|115|80|115|115|115¬'+
isnull((select STUFF((select '¬'+convert(varchar,p.ProductoNombre)+'|'+CONVERT(varchar,p.ProductoCantidad)
+'|'+p.ProductoUM+'|'+CONVERT(varchar,p.ProductoVenta)+'|'+
CONVERT(varchar,p.ProductoVentaB)+'|'+CONVERT(varchar,p.ProductoCosto)+'|'+convert(varchar,p.IdSubLinea)
from Producto p
for XMl path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[MRDuenasB]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[MRDuenasB]  
as  
begin  
select 'Categoria|Productos['+  
isnull((select STUFF((select '¬'+ convert(varchar,s.IdSubLinea)  
+'|'+s.NombreSublinea  
from Sublinea s  
order by s.NombreSublinea asc  
for XMl path('')),1,1,'')),'~')+'['+  
isnull((select STUFF((select '¬'+ convert(varchar,p.IdProducto)+'|'+  
convert(varchar,p.ProductoNombre)+'|'+  
CONVERT(varchar,p.ProductoVenta)+'|'+  
CONVERT(varchar,p.ProductoCantidad)+'|'+p.ProductoUM+'|'+  
convert(varchar,p.ProductoCosto)+'|'+CONVERT(varchar,s.EnviarIMP)+'|'+  
convert(varchar,p.IdSubLinea)  
from Producto p  
inner join Sublinea s  
on s.IdSubLinea=p.IdSubLinea  
WHERE p.ProductoEstado='BUENO'  
order by s.NombreSublinea,p.ProductoNombre asc  
for XMl path('')),1,1,'')),'~')  
end
GO
/****** Object:  StoredProcedure [dbo].[MRDuenasC]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[MRDuenasC]    
as    
begin    
select 'Id|SubLinea|Selec¬0|235|50¬String|String|Boolean¬'+    
isnull((select STUFF((select '¬'+ convert(varchar,s.IdSubLinea)+'|'+s.NombreSublinea    
+'|'+convert(char(1),0)    
from Sublinea s    
for XMl path('')),1,1,'')),'~')+'['+    
'ID|Codigo|Descripcion|Inventario|UM|Cantidad|PreVenta|PreCosto¬90|90|90|80|90|90|90|90¬String|String|String|String|String|String|String|String¬'+    
isnull((select STUFF((select '¬'+convert(varchar,p.IdProducto)+'|'+    
p.ProductoCodigo+'|'+p.ProductoNombre+'||'+p.ProductoUM+'|'+    
CONVERT(varchar,p.ProductoCantidad)+'|'+    
CONVERT(varchar,p.ProductoVenta)+'|'+    
CONVERT(varchar,p.ProductoCosto)+'|'+    
convert(varchar,p.IdSubLinea)    
from Producto p    
where p.ProductoEstado='BUENO'    
order by p.IdSubLinea asc,p.ProductoNombre asc    
for XMl path('')),1,1,'')),'~')    
end
GO
/****** Object:  StoredProcedure [dbo].[obtenerIdOrden]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[obtenerIdOrden]
	@id_mesa int 
as
begin
select top 1 convert(nvarchar,o.IdOrden) + '|'+ 
convert(nvarchar,REPLACE(O.NroMesas,'MESA ',''))
from tbl_orden_pedido o 
inner join Combinacion_Mesas c 
on o.IdOrden=c.IdOrden
inner join tbl_mesa m 
on c.id_mesa = m.id_mesa
where c.id_mesa=@id_mesa and m.estado <> 'LIBRE' and (o.estado<>'ANULADO' and o.estado<>'CANCELADO')
order by o.IdOrden desc
end
GO
/****** Object:  StoredProcedure [dbo].[permisoElimina]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[permisoElimina]
@Codigo varchar(60)
as
begin
select top 1 (((SUBSTRING(p.PersonalNombres+' ',1,CHARINDEX(' ',p.PersonalNombres+' ')-1)))+' '+ ((SUBSTRING(p.PersonalApellidos+' ',1,CHARINDEX(' ',p.PersonalApellidos+' ')-1))))as USUARIO 
from Personal p
where PersonalCodigo=@Codigo and (AreaId=6 or AreaId=7 or AreaId=12)
end
GO
/****** Object:  StoredProcedure [dbo].[pruebaB]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[pruebaB]
as
begin
select
'DetalleId|UM¬100|120¬String|String¬'+
(select STUFF((select '¬'+convert(varchar,d.DetalleId)+'|'+
p.ProductoUM
from DetalleGuia d
inner join Producto p
on p.IdProducto=d.IdProducto
for XML path('')),1,1,''))
end
GO
/****** Object:  StoredProcedure [dbo].[reporteGanancia]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[reporteGanancia] 
@anno int
as
begin
select 'Numero|Mes|Ventas|G_Ventas|Gastos|G_Liquida¬80|100|110|110|105|110¬String|String|String|String|String|String¬'+
(select STUFF((select '¬'+ convert(varchar,isnull(a.Numero,g.Numero))+'|'+convert(varchar,ISNULL(a.Mes,g.Mes))+'|'+
	CONVERT(VarChar(50), cast(isnull(a.Ventas,0) as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(isnull(a.Ganancia,0)as money ), 1)+'|'+
	CONVERT(VarChar(50), cast(isnull(g.Gastos,0) as money ), 1)+'|'+
	CONVERT(VarChar(50), cast((isnull(a.Ganancia,0)-isnull(g.Gastos,0)) as money ), 1)
	from	
(select month(n.NotaFecha) as Numero,DATENAME(month,n.NotaFecha) as Mes,sum(n.NotaPagar) as Ventas,
sum(n.NotaGanancia)- SUM(n.NotaDescuento)as Ganancia --GANANCIA
from 
	NotaPedido n(noLOCK) 
	where n.NotaEstado='CANCELADO' and YEAR(n.NotaFecha)=@anno
	group by month(n.NotaFecha),DATENAME(month,n.NotaFecha))a
full join(
	select month(g.GastoFecha) as Numero,DATENAME(month,g.GastoFecha) as Mes,SUM(g.GstoMonto) as Gastos 
	from GastosFijos g (noLOCK) --GASTOS
	where YEAR(g.GastoFecha)=@anno
	group by month(g.GastoFecha),DATENAME(month,g.GastoFecha)
)g on a.Numero=g.Numero
order by a.Numero desc,g.Numero desc
FOR XML PATH('')),1,1,''))
end
GO
/****** Object:  StoredProcedure [dbo].[reporteGananciaB]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[reporteGananciaB] 
@Mes int,
@anno int
as
begin
select isnull(a.Numero,g.Numero) as Numero,ISNULL(a.Mes,g.Mes) as Mes,
CONVERT(VarChar(50), cast(isnull(v.TotalVenta,0) as money ), 1) as TotalVenta,
CONVERT(VarChar(50), cast((isnull(a.Ganancia,0))as money ), 1) as G_Ventas,
CONVERT(VarChar(50), cast(isnull(g.Gastos,0) as money ), 1) as Gatos,
CONVERT(VarChar(50), cast((isnull(a.Ganancia,0)-isnull(g.Gastos,0)) as money ), 1) as G_Liquida
from
(select month(n.NotaFecha) as Numero,DATENAME(month,n.NotaFecha) as Mes,
sum(n.NotaGanancia)- SUM(n.NotaDescuento) as Ganancia--ganancia
from 
NotaPedido n
where n.NotaEstado='CANCELADO' and (MONTH(n.NotaFecha)=@Mes and YEAR(n.NotaFecha)=@anno)
group by month(n.NotaFecha),DATENAME(month,n.NotaFecha))a
full join(
select month(g.GastoFecha) as Numero,DATENAME(month,g.GastoFecha) as Mes,SUM(g.GstoMonto) as Gastos 
from GastosFijos g--gastos
where(Month(g.GastoFecha)=@Mes and YEAR(g.GastoFecha)=@anno)
group by month(g.GastoFecha),DATENAME(month,g.GastoFecha)
)g on a.Numero=g.Numero
full join(select month(n.NotaFecha) as Numero,
DATENAME(month,n.NotaFecha) as Mes,SUM(n.NotaPagar) as TotalVenta 
from NotaPedido n--total venta
where (Month(n.NotaFecha)=@Mes and YEAR(n.NotaFecha)=@anno) and n.NotaEstado='CANCELADO'
group by month(n.NotaFecha),DATENAME(month,n.NotaFecha)
)v on a.Numero=v.Numero
group by a.Numero,g.Numero,a.Mes,g.Mes,v.TotalVenta,a.Ganancia,g.Gastos
order by 1 desc
end
GO
/****** Object:  StoredProcedure [dbo].[reportePDT]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[reportePDT]
@CompaniaId int,
@Mes int,
@Anno int
as
begin
select isnull(b.CompaniaId,isnull(S.CompaniaId,isnull(d.CompaniaId,isnull(x.CompaniaId,z.CompaniaId)))) as CompaniaId,
convert(varchar(50),cast((ISNULL(b.Monto,0))as money),1) as Ventas,
convert(varchar(50),cast((ISNULL(s.Monto,0)+ISNULL(d.Monto,0))-(ISNULL(x.Monto,0)+ISNULL(z.Monto,0))as money),1) as Compras
from
(
select d.CompaniaId,sum(d.DocuTotal) as Monto--VENTASSS
from DocumentoVenta d
where d.CompaniaId=@companiaId and(month(d.DocuEmision)=@Mes and year(d.DocuEmision)=@Anno)and (d.DocuDocumento<>'PROFORMA V' AND d.DocuDocumento<>'NOTA PEDIDO') and d.DocuEstado<>'ANULADO'
group by d.CompaniaId
)b
full join(
select c.CompaniaId,sum(c.CompraTotal) as Monto
from Compras c--FACTURAS EN SOLES
where c.CompaniaId=@companiaId and(month(c.CompraComputo)=@Mes and year(c.CompraComputo)=@Anno)AND(c.TipoCodigo='01' and c.CompraMoneda='SOLES')
group by c.CompaniaId
)s on b.CompaniaId=s.CompaniaId
full join
(select c.CompaniaId,cast(sum(c.CompraTotal*c.CompraTipoSunat)as decimal(18,2)) as Monto
from Compras c--FACTURAS EN DOLARES
where c.CompaniaId=@companiaId and (month(c.CompraComputo)=@Mes and year(c.CompraComputo)=@Anno)AND(c.TipoCodigo='01' and c.CompraMoneda='DOLARES')
group by c.CompaniaId
)d on b.CompaniaId=d.CompaniaId
full join(
select c.CompaniaId,cast(sum(c.CompraTotal*c.CompraTipoSunat)as decimal(18,2)) as Monto
from Compras c--nota de credito en dolares
where c.CompaniaId=@companiaId and(month(c.CompraComputo)=@Mes and year(c.CompraComputo)=@Anno)AND(c.TipoCodigo='07' and c.CompraMoneda='DOLARES')
group by c.CompaniaId
)x on b.CompaniaId=x.CompaniaId
full join (
select c.CompaniaId,sum(c.CompraTotal) as Monto
from Compras c--nota de credito en soles
where c.CompaniaId=@companiaId and(month(c.CompraComputo)=@Mes and year(c.CompraComputo)=@Anno)AND(c.TipoCodigo='07' and c.CompraMoneda='SOLES')
group by c.CompaniaId
)z on b.CompaniaId=z.CompaniaId
end
GO
/****** Object:  StoredProcedure [dbo].[reporteVentaCompania]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[reporteVentaCompania]
@Mes int,
@Anno int
as
begin
select top 2 isnull(b.CompaniaId,isnull(S.CompaniaId,isnull(d.CompaniaId,isnull(x.CompaniaId,z.CompaniaId)))) as CompaniaId,
ISNULL(b.RazonSocial,isnull(S.RazonSocial,isnull(d.RazonSocial,isnull(x.RazonSocial,z.RazonSocial))))as RazonSocial,
convert(varchar(50),cast((ISNULL(b.Monto,0))as money),1) as Ventas,
convert(varchar(50),cast(((ISNULL(s.Monto,0)+ISNULL(d.Monto,0))-(ISNULL(x.Monto,0)+ISNULL(z.Monto,0)))as money),1) as Compras
from
(
select top 2 c.CompaniaId,c.CompaniaRazonSocial as RazonSocial,
sum(d.DocuTotal) as Monto--VENTASSS
from DocumentoVenta d
inner join Compania c
on c.CompaniaId=d.CompaniaId
where (Month(d.DocuEmision)=@Mes and year(d.DocuEmision)=@Anno) and (d.DocuDocumento<>'PROFORMA V' AND d.DocuDocumento<>'NOTA PEDIDO' AND d.DocuDocumento<>'NOTA DE CREDITO') and d.DocuAsociado=''
group by c.CompaniaId,c.CompaniaRazonSocial
)b
full join(
select TOP 2 co.CompaniaId,co.CompaniaRazonSocial as RazonSocial,sum(c.CompraTotal) as Monto
from Compras c--FACTURAS EN SOLES
inner join Compania co
on co.CompaniaId=c.CompaniaId
where (Month(c.CompraComputo)=@Mes and year(c.CompraComputo)=@Anno)AND(c.TipoCodigo='01' and c.CompraMoneda='SOLES')
group by co.CompaniaId,co.CompaniaRazonSocial
)s on b.CompaniaId=s.CompaniaId
full join
(select TOP 2 co.CompaniaId,co.CompaniaRazonSocial as RazonSocial,cast(sum(c.CompraTotal*c.CompraTipoSunat)as decimal(18,2)) as Monto
from Compras c--FACTURAS EN DOLARES
inner join Compania co
on co.CompaniaId=c.CompaniaId
where(Month(c.CompraComputo)=@Mes and year(c.CompraComputo)=@Anno)AND(c.TipoCodigo='01' and c.CompraMoneda='DOLARES')
group by co.CompaniaId,co.CompaniaRazonSocial
)d on b.CompaniaId=d.CompaniaId
full join(
select TOP 2 co.CompaniaId,co.CompaniaRazonSocial as RazonSocial,cast(sum(c.CompraTotal*c.CompraTipoSunat)as decimal(18,2)) as Monto
from Compras c--nota de credito en dolares
inner join Compania co
on co.CompaniaId=c.CompaniaId
where(Month(c.CompraComputo)=@Mes and year(c.CompraComputo)=@Anno)AND(c.TipoCodigo='07' and c.CompraMoneda='DOLARES')
group by co.CompaniaId,co.CompaniaRazonSocial
)x on b.CompaniaId=x.CompaniaId
full join (
select TOP 2 co.CompaniaId,co.CompaniaRazonSocial as RazonSocial,sum(c.CompraTotal) as Monto
from Compras c--nota de credito en soles
inner join Compania co
on co.CompaniaId=c.CompaniaId
where(Month(c.CompraComputo)=@Mes and year(c.CompraComputo)=@Anno)AND(c.TipoCodigo='07' and c.CompraMoneda='SOLES')
group by co.CompaniaId,co.CompaniaRazonSocial
)z on b.CompaniaId=z.CompaniaId
end
GO
/****** Object:  StoredProcedure [dbo].[respaldoBD]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[respaldoBD]
as
begin
declare @fecha varchar(max)
declare @hora varchar(max)
declare @archivo varchar(max)

set @fecha=CONVERT(Varchar(10),GETDATE(),105)
set @hora=REPLACE(CONVERT(varchar(10), GETDATE(), 108),':','-')
set @archivo='C:\Users\HP\OneDrive\Bakup\ROSITA-'+@fecha+'-'+@hora+'.bak'--'D:\Archivo_Sistema\Backup\ROSITA-'+@fecha+'-'+@hora+'.bak'

BACKUP DATABASE ROSITA TO DISK=@archivo
WITH FORMAT,
NAME='ROSITA';
end
GO
/****** Object:  StoredProcedure [dbo].[rptCompraA]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[rptCompraA]
as
begin
select c.CompraId,Convert(char(10),c.CompraEmision,103) as FechaEmision,c.CompraSerie+'-'+c.CompraNumero as Documento,
p.ProveedorRuc as RUC,p.ProveedorRazon as RazonSocial,c.TipoCodigo as TipoCodigo,
case when c.CompraMoneda='DOLARES' THEN
CONVERT(VarChar(50), cast((c.CompraTotal/1.18)*c.CompraTipoSunat as money ), 1)
else  CONVERT(VarChar(50), cast((c.CompraTotal/1.18) as money ), 1)
end as SubTotal,
case when c.CompraMoneda='DOLARES' then
CONVERT(VarChar(50), cast((c.CompraTotal-(c.CompraTotal/1.18))*c.CompraTipoSunat as money ), 1)
else CONVERT(VarChar(50), cast((c.CompraTotal-(c.CompraTotal/1.18))as money ), 1)
end as IGV,
case when c.CompraMoneda='DOLARES' then
CONVERT(VarChar(50), cast((c.CompraTotal *c.CompraTipoSunat) as money ), 1)
else CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1)
end as Total,c.CompraMoneda as Moneda,c.CompraTipoSunat as TipoSunat,CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1) as Monto
from Compras c
inner join Proveedor p
on p.ProveedorId=c.ProveedorId
end
GO
/****** Object:  StoredProcedure [dbo].[rptCompraComputo]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[rptCompraComputo] @fechainicio date,@fechafin date,@CompaniaId int
as
begin
select c.CompraId,Convert(char(10),c.CompraEmision,103) as FechaEmision,c.CompraSerie+'-'+c.CompraNumero as Documento,
p.ProveedorRuc as RUC,p.ProveedorRazon as RazonSocial,c.TipoCodigo as TipoCodigo,
case when c.CompraMoneda='DOLARES' THEN
CONVERT(VarChar(50), cast((c.CompraTotal/1.18)*c.CompraTipoSunat as money ), 1)
else  CONVERT(VarChar(50), cast((c.CompraTotal/1.18) as money ), 1)
end as SubTotal,
case when c.CompraMoneda='DOLARES' then
CONVERT(VarChar(50), cast((c.CompraTotal-(c.CompraTotal/1.18))*c.CompraTipoSunat as money ), 1)
else CONVERT(VarChar(50), cast((c.CompraTotal-(c.CompraTotal/1.18))as money ), 1)
end as IGV,
case when c.CompraMoneda='DOLARES' then
CONVERT(VarChar(50), cast((c.CompraTotal *c.CompraTipoSunat) as money ), 1)
else CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1)
end as Total,c.CompraMoneda as Moneda,c.CompraTipoSunat as TipoSunat,CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1) as Monto
from Compras c
inner join Proveedor p
on p.ProveedorId=c.ProveedorId
where (Convert(char(10),c.CompraComputo,103) BETWEEN @fechainicio AND @fechafin) and (c.TipoCodigo='01' or c.TipoCodigo='07') and c.CompaniaId=@CompaniaId
order by c.CompraEmision asc
end
GO
/****** Object:  StoredProcedure [dbo].[rptCompraEmision]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[rptCompraEmision] @fechainicio date,@fechafin date,@CompaniaId int
as
begin
select c.CompraId,Convert(char(10),c.CompraEmision,103) as FechaEmision,c.CompraSerie+'-'+c.CompraNumero as Documento,
p.ProveedorRuc as RUC,p.ProveedorRazon as RazonSocial,c.TipoCodigo as TipoCodigo,
case when c.CompraMoneda='DOLARES' THEN
CONVERT(VarChar(50), cast((c.CompraTotal/1.18)*c.CompraTipoSunat as money ), 1)
else  CONVERT(VarChar(50), cast((c.CompraTotal/1.18) as money ), 1)
end as SubTotal,
case when c.CompraMoneda='DOLARES' then
CONVERT(VarChar(50), cast((c.CompraTotal-(c.CompraTotal/1.18))*c.CompraTipoSunat as money ), 1)
else CONVERT(VarChar(50), cast((c.CompraTotal-(c.CompraTotal/1.18))as money ), 1)
end as IGV,
case when c.CompraMoneda='DOLARES' then
CONVERT(VarChar(50), cast((c.CompraTotal *c.CompraTipoSunat) as money ), 1)
else CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1)
end as Total,c.CompraMoneda as Moneda,c.CompraTipoSunat as TipoSunat,CONVERT(VarChar(50), cast(c.CompraTotal as money ), 1) as Monto
from Compras c
inner join Proveedor p
on p.ProveedorId=c.ProveedorId
where (Convert(char(10),c.CompraEmision,103) BETWEEN @fechainicio AND @fechafin) and (c.TipoCodigo='01' or c.TipoCodigo='07') and c.CompaniaId=@CompaniaId
order by c.CompraEmision asc
end
GO
/****** Object:  StoredProcedure [dbo].[rptMes]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[rptMes]
@Mes int,
@Anno int
as 
begin
select
'Dia|Fecha|Venta|Ganancia|Gastos|GananciaLQ¬80|105|103|103|103|103¬String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+
convert(varchar,isnull(a.Dia,b.Dia))+'|'+convert(varchar,isnull(a.Fecha,b.Fecha))+'|'+
convert(varchar(50),cast(isnull(a.VentaTotal,0)as money),1)+'|'+
convert(varchar(50),cast(isnull(a.GananciaTotal,0)as money),1)+'|'+
convert(varchar(50),cast(isnull(b.Gastos,0)as money),1)+'|'+
convert(varchar(50),cast(isnull(a.GananciaTotal,0)-isnull(b.Gastos,0)as money),1)
from
(select DAY(n.NotaFecha) as Dia,
dbo.diaNombre(n.NotaFecha)+' '+convert(nvarchar,DAY(n.NotaFecha)) as Fecha,
SUM(n.NotaPagar)as VentaTotal,
SUM(NotaGanancia)- SUM(n.NotaDescuento) as GananciaTotal
from NotaPedido n
where (month(n.NotaFecha)=@Mes and year(n.NotaFecha)=@Anno) and n.NotaEstado='CANCELADO'
group by DAY(n.NotaFecha),dbo.diaNombre(n.NotaFecha))a
full join(
	select DAY(g.GastoFecha) as Dia,
	dbo.diaNombre(g.GastoFecha)+' '+convert(nvarchar,DAY(g.GastoFecha)) as Fecha,
	SUM(g.GstoMonto) as Gastos 
	from GastosFijos g (noLOCK) 
	where (month(g.GastoFecha)=@Mes and year(g.GastoFecha)=@Anno)
	group by DAY(g.GastoFecha),dbo.diaNombre(g.GastoFecha)
)b on a.Dia=b.Dia
order by a.Dia DESC
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[rptSemanal]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[rptSemanal]
@Fecha date,
@Anno int
as
begin
declare @NumSemana int
set @NumSemana=(select DATEPART(WK,@Fecha))
select
'Dia|Fecha|Venta|Ganancia|Gastos|GananciaLQ¬80|113|105|105|105|105¬String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+
convert(varchar,isnull(a.Dia,b.Dia))+'|'+convert(varchar,isnull(a.Fecha,b.Fecha))+'|'+
convert(varchar(50),cast(isnull(a.VentaTotal,0)as money),1)+'|'+
convert(varchar(50),cast(isnull(a.GananciaTotal,0)as money),1)+'|'+
convert(varchar(50),cast(isnull(b.Gastos,0)as money),1)+'|'+
convert(varchar(50),cast(isnull(a.GananciaTotal,0)-isnull(b.Gastos,0)as money),1)
from
(select DAY(n.NotaFecha) as Dia,
dbo.diaNombre(n.NotaFecha)+' '+convert(nvarchar,DAY(n.NotaFecha)) as Fecha,
SUM(n.NotaPagar)as VentaTotal,
SUM(NotaGanancia)- SUM(n.NotaDescuento) as GananciaTotal
from NotaPedido n
where ((DATEPART(WK,n.NotaFecha)=@NumSemana)and year(n.NotaFecha)=@Anno) and n.NotaEstado='CANCELADO'
group by DAY(n.NotaFecha),dbo.diaNombre(n.NotaFecha))a
full join(
	select DAY(g.GastoFecha) as Dia,
	dbo.diaNombre(g.GastoFecha)+' '+convert(nvarchar,DAY(g.GastoFecha)) as Fecha,
	SUM(g.GstoMonto) as Gastos 
	from GastosFijos g (noLOCK) 
	where((DATEPART(WK,g.GastoFecha)=@NumSemana) and YEAR(g.GastoFecha)=@Anno)
    group by DAY(g.GastoFecha),dbo.diaNombre(g.GastoFecha)
)b on a.Dia=b.Dia
order by a.Dia ASC
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[rptVendedor]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[rptVendedor]   
@Mes INT,  
@ANNO INT  
as  
begin 
select
'Personal|Clientes|Ventas|SubTotal|IGV|Ganancia|ImpRenta|Descuento|DesTotal|GLiquida¬185|105|125|125|125|125|125|125|125|125¬String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF ((select '¬'+isnull(a.Usuario,b.Usuario)+'|'+  
convert(varchar,ISNULL(a.Cliente,0))+'|'+  
convert(varchar(50),cast((isnull(a.Venta,0)) as money),1)+'|'+--converiertes a moneda y despues conviertes a texto
convert(varchar(50),cast(((isnull(b.Ganancia,0)/1.18))as money),1)+'|'+
convert(varchar(50),cast((isnull(b.Ganancia,0)-(cast((isnull(b.Ganancia,0)/1.18)as decimal(18,2))))as money),1)+'|'+   
convert(varchar(50),cast((isnull(b.Ganancia,0))as money),1)+'|'+ 
convert(varchar(50),cast((cast((isnull(a.Venta,0)* 0.01) as decimal(18,2)))as money),1)+'|'+   
convert(varchar(50),cast((isnull(a.Descuento,0))as money),1)+'|'+   
convert(varchar(50),cast(((cast((isnull(b.Ganancia,0)-(cast((isnull(b.Ganancia,0)/1.18)as decimal(18,2))))as decimal(18,2))+  
cast((isnull(a.Venta,0)* 0.01) as decimal(18,2)))+isnull(a.Descuento,0))as money),1)+'|'+   
convert(varchar(50),cast((isnull(b.Ganancia,0)-((cast((isnull(b.Ganancia,0)-(cast((isnull(b.Ganancia,0)/1.18)as decimal(18,2))))as decimal(18,2))+cast((isnull(a.Venta,0)* 0.01) as decimal(18,2)))+isnull(a.Descuento,0)))as money),1)
from   
(  
	select n.NotaUsuario as Usuario,COUNT(ClienteId) as Cliente,SUM(n.NotaPagar) as Venta,SUM(n.NotaDescuento) as Descuento  
	from NotaPedido n (NOLOCK) 
	where (
		month(n.NotaFecha)=@Mes and
		YEAR(n.NotaFecha)=@ANNO) and
		n.NotaEstado='CANCELADO'
	group by n.NotaUsuario)a  
	FULL join(
	select n.NotaUsuario as Usuario,sum(n.NotaGanancia) as Ganancia--cast(Sum((d.DetallePrecio - d.DetalleCosto) * d.DetalleCantidad)as decimal(18,2)) as Ganancia  --ok
	--from DetallePedido d (NOLOCK) 
	--inner join 
	from NotaPedido n  (NOLOCK) 
	--on n.NotaId=d.NotaId
	where (month(n.NotaFecha)=@Mes and 
	YEAR(n.NotaFecha)=@ANNO) and 
	n.NotaEstado='CANCELADO'  
	group by n.NotaUsuario  
)b on a.Usuario=b.Usuario  
group by a.Usuario,b.Usuario,a.Cliente,a.Venta,a.Descuento,b.Ganancia  
order by a.Cliente desc 
for xml path('')),1,1,'')),'~') 
end
GO
/****** Object:  StoredProcedure [dbo].[TipoCambioFecha]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[TipoCambioFecha] 
@fechainicio date,
@fechafin date
as
begin
select
'ID|Fecha|COMPRA|VENTA|EMPRESA¬90|110|108|108|117¬String|String|String|String|String¬'+
(select STUFF((select '¬'+ convert(varchar,t.IdTipo),+'|'+
(Convert(char(10),t.TipoFecha,103))+'|'+convert(varchar,t.TipoCompra)+'|'+
convert(varchar,t.TipoVenta)+'|'+
convert(varchar,t.TipoEmpresa) 
from TipoCambio t 
where t.TipoFecha BETWEEN @fechainicio AND @fechafin 
order by t.TipoFecha asc
for xml path('')),1,1,''))
end
GO
/****** Object:  StoredProcedure [dbo].[totalLetras]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[totalLetras] @numero decimal(18,2),@Moneda varchar(60)
as
begin
select dbo.letras(@numero,@Moneda) as letras
end
GO
/****** Object:  StoredProcedure [dbo].[traerProducto]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[traerProducto] 
@codigo varchar(80)
as
begin
SELECT top 1 p.IdProducto,s.NombreSublinea,p.ProductoCodigo,p.ProductoNombre,
p.ProductoCantidad, p.ProductoUM,p.ProductoVenta,p.ProductoVentaB,p.ProductoCosto,  
p.ProductoEstado,p.ProductoUsuario,p.ProductoFecha,p.ProductoImagen,
p.ValorCritico
FROM Producto p
INNER JOIN Sublinea s
ON p.IdSubLinea =s.IdSubLinea
where p.ProductoCodigo=@codigo
order by p.IdProducto desc
end
GO
/****** Object:  StoredProcedure [dbo].[upsAgregarEliminarMesas]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[upsAgregarEliminarMesas]
@Data varchar(max)
AS
BEGIN
	Declare @p1 int,@p2 int, @p3 int, @p4 int	
	Declare @id_orden_pedido int,
			@id_mesa int, -- Mesa a eliminar ó agregar				
			@condicion int, 			
			@id_mesas_orden nvarchar(30) -- las mesas de la orden : ejm 1,2,4,
    Declare @Mesas varchar(80)
	Set @Data = LTRIM(RTrim(@Data))
	Set @p1 = CharIndex('|',@Data,0)
	Set @p2 = CharIndex('|',@Data,@p1+1)		
	Set @p3 = CharIndex('|',@Data,@p2+1)		
	Set @p4 = Len(@Data)+1
			
	Set @id_orden_pedido	=convert(int,SUBSTRING(@Data,1,@p1-1))
	Set @id_mesa			=convert(int,SUBSTRING(@Data,@p1+1,@p2-@p1-1))
	Set	@condicion			=convert(int,SUBSTRING(@Data,@p2+1,@p3-@p2-1))		
	Set	@id_mesas_orden		=SUBSTRING(@Data,@p3+1,@p4-@p3-1)
	
	if(@condicion = 0)		
		BEGIN	--AGREGAR MESA
			insert into combinacion_mesas values (@id_orden_pedido, @id_mesa)
		    
			set @Mesas=(select isnull((select STUFF ((select ','+'MESA '+convert(varchar,m.id_mesa)
            from Combinacion_Mesas c inner join tbl_mesa m
            on m.id_mesa=c.id_mesa where c.IdOrden=@id_orden_pedido
            order by m.id_mesa asc
            for xml path('')),1,1,'')),'~'))
			
						
			update tbl_mesa
			set estado='OCUPADA'
			where id_mesa = @id_mesa
			
			update Tbl_Orden_Pedido 
			set NroMesas=@Mesas
			where IdOrden=@id_orden_pedido				
			
			select REPLACE(@Mesas,'MESA ','')+'¬'+@Mesas	
		END		
	ELSE
		BEGIN --ELIMINAR MESA
			delete from Combinacion_Mesas 
			where IdOrden=@id_orden_pedido and id_mesa=@id_mesa
			
			set @Mesas=(select isnull
			((select STUFF ((select ','+'MESA '+convert(varchar,m.id_mesa)
            from Combinacion_Mesas c inner join tbl_mesa m
            on m.id_mesa=c.id_mesa where c.IdOrden=@id_orden_pedido
            order by m.id_mesa asc
            for xml path('')),1,1,'')),'~'))	
									
			update tbl_mesa 
			set estado='LIBRE' 
			where id_mesa = @id_mesa
			
			update Tbl_Orden_Pedido 
			set NroMesas=@Mesas
			where IdOrden=@id_orden_pedido					
			
			select REPLACE(@Mesas,'MESA ','')+'¬'+@Mesas		
		END
END
GO
/****** Object:  StoredProcedure [dbo].[upsEditarCombinacionMesas]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[upsEditarCombinacionMesas]
@Data varchar(max)
AS
BEGIN
	Declare @p1 int,@p2 int,
	@p3 int,@p4 int
	Declare 
		@id_orden_pedido numeric(38),
		@id_mesa int,
		@id_mesa_update int,
		@id_mesas_orden varchar(80),
		@EstadoMesa varchar(20)	
	Set @Data = LTRIM(RTrim(@Data))
	Set @p1 = CharIndex('|',@Data,0)
	Set @p2 = CharIndex('|',@Data,@p1+1)	
	Set @p3 = CharIndex('|',@Data,@p2+1)	
	Set @p4 = Len(@Data)+1		
	Set @id_orden_pedido =convert(numeric(38),SUBSTRING(@Data,1,@p1-1))
	Set @id_mesa         =convert(int,SUBSTRING(@Data,@p1+1,@p2-@p1-1))
	Set	@id_mesa_update	 =convert(int,SUBSTRING(@Data,@p2+1,@p3-@p2-1))	
	Set @id_mesas_orden	 =SUBSTRING(@Data,@p3+1,@p4-@p3-1)
	
	set @EstadoMesa=(select top 1 m.estado from tbl_mesa m where m.id_mesa=@id_mesa)
		
	update combinacion_mesas
	set id_mesa=@id_mesa_update
	where id_mesa=@id_mesa and IdOrden=@id_orden_pedido			
	
	update tbl_mesa 
	set estado=@EstadoMesa
	where id_mesa = @id_mesa_update
	
	update tbl_mesa 
	set estado='LIBRE'
	where id_mesa = @id_mesa	
	
	update tbl_orden_pedido 
	set NroMesas='MESA '+@id_mesas_orden 
	where IdOrden=@id_orden_pedido	
	
	select 'true'
END
GO
/****** Object:  StoredProcedure [dbo].[uspAnularNC]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspAnularNC]
@ListaOrden varchar(Max)
as
begin
Declare @pos int
Declare @orden varchar(max)
Declare @detalle varchar(max)
Set @pos = CharIndex('[',@ListaOrden,0)
Set @orden = SUBSTRING(@ListaOrden,1,@pos-1)
Set @detalle = SUBSTRING(@ListaOrden,@pos+1,len(@ListaOrden)-@pos)
declare @1 int,@2 int,@3 int,@4 int,@5 int
declare @DocuId numeric(38),@NotaId numeric(38),
@DocuUsuario varchar(80),@DocuAsociado varchar(80),@KardexDocu varchar(80)
Set @orden= LTRIM(RTrim(@orden))
Set @1 = CharIndex('|',@orden,0)
Set @2 = CharIndex('|',@orden,@1+1)
Set @3 = CharIndex('|',@orden,@2+1)
Set @4 = CharIndex('|',@orden,@3+1)
Set @5 = Len(@orden)+1
Set @DocuId=convert(numeric(38),SUBSTRING(@orden,1,@1-1))
Set @NotaId=convert(numeric(38),SUBSTRING(@orden,@1+1,@2-@1-1))
Set @DocuUsuario=SUBSTRING(@orden,@2+1,@3-@2-1)
Set @DocuAsociado=SUBSTRING(@orden,@3+1,@4-@3-1)
Set @KardexDocu=SUBSTRING(@orden,@4+1,@5-@4-1)
Begin Transaction
update DocumentoVenta
set DocuSubTotal=0,DocuIgv=0,DocuTotal=0,DocuSaldo=0,DocuUsuario=@DocuUsuario,DocuEstado='ANULADO'
where DocuId=@DocuId
update DocumentoVenta
set DocuAsociado=''
where DocuId=@DocuAsociado
 Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
Declare @Columna varchar(max),
		@IdProducto numeric(20),
		@Cantidad decimal(18,2),
		@Precio decimal(18,2),
		@Importe decimal(18,2),
		@DetalleNotaId numeric(38),
		@UM varchar(80),
		@ValorUM decimal(18,4),
		@StockInicial decimal(18,2),
		@StockFinal decimal(18,2),@CantidadSal decimal(18,2)
Declare @p1 int,@p2 int,@p3 int,@p4 int,
        @p5 int,@p6 int,@p7 int
Fetch Next From Tabla INTO @Columna
	While @@FETCH_STATUS = 0
	Begin
Set @p1 = CharIndex('|',@Columna,0)
Set @p2 = CharIndex('|',@Columna,@p1+1)
Set @p3 = CharIndex('|',@Columna,@p2+1)
Set @p4 = CharIndex('|',@Columna,@p3+1)
Set @p5 = CharIndex('|',@Columna,@p4+1)
Set @p6= CharIndex('|',@Columna,@p5+1)
Set @p7 = Len(@Columna)+1
Set @Cantidad=Convert(decimal(18,2),SUBSTRING(@Columna,1,@p1-1))
Set @UM=SUBSTRING(@Columna,@p1+1,@p2-(@p1+1))
Set @Precio=Convert(decimal(18,2),SUBSTRING(@Columna,@p2+1,@p3-(@p2+1)))
Set @Importe=Convert(decimal(18,2),SUBSTRING(@Columna,@p3+1,@p4-(@p3+1)))
Set @DetalleNotaId=Convert(numeric(38),SUBSTRING(@Columna,@p4+1,@p5-(@p4+1)))
Set @IdProducto=Convert(numeric(20),SUBSTRING(@Columna,@p5+1,@p6-(@p5+1)))
Set @ValorUM=Convert(decimal(18,4),SUBSTRING(@Columna,@p6+1,@p7-(@p6+1)))
set @StockInicial=(select top 1 ProductoCantidad from Producto where IdProducto=@IdProducto)
set @CantidadSal=(@Cantidad*@ValorUM)
set @StockFinal=@StockInicial-@CantidadSal
update Producto
set ProductoCantidad=ProductoCantidad-@CantidadSal
where IdProducto=@IdProducto
insert into Kardex
values(@IdProducto,GETDATE(),'Anulacion por Nota Credito',@KardexDocu,@StockInicial,0,@CantidadSal,@Precio,@StockFinal,'SALIDA',@DocuUsuario)
Fetch Next From Tabla INTO @Columna
end
	Close Tabla;
	Deallocate Tabla;
	Commit Transaction;
select
isnull((select STUFF ((select '¬'+convert(varchar,d.DocuId)+'|'+convert(varchar,d.CompaniaId)+'|'+
convert(varchar,d.NotaId)+'|'+(Convert(char(10),d.DocuEmision,103))+'|'+
d.DocuDocumento+'|'+d.docuSerie+'-'+d.DocuNumero+'|'+c.ClienteRazon+'|'+c.ClienteRuc+'|'+
c.ClienteDni+'|'+d.DocuNumero+'|'+d.DocuSerie+'|'+
(convert(varchar(50), CAST(d.DocuSubTotal as money),1))+'|'+
(convert(varchar(50), CAST(d.DocuIgv as money),1))+'|'+
(convert(varchar(50), CAST(d.DocuTotal as money),1))+'|'+
d.DocuUsuario+'|'+d.DocuEstado+'|'+c.ClienteDireccion+'|'+d.DocuAsociado
from DocumentoVenta d
inner join Cliente c
on c.ClienteId=d.ClienteId
where d.TipoCodigo='07'and (Month(d.DocuEmision)=Month(GETDATE())and year(d.DocuEmision)=YEAR(Getdate()))
order by d.DocuId desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspAsistenciaDia]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uspAsistenciaDia]
@fechainicio date,
@fechafin date
as
Begin
select 
'Id|Fecha|Dia|PersonalId|Nombres|HoraIngreso|IngresoRefrigerio|RetornoRefrigerio|HoraSalida|NroMar|HoraING|HoraREF¬90|100|100|100|220|125|125|125|125|70|90|90¬String|String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+Convert(varchar,a.Id)+'|'+
convert(varchar,a.Fecha,103)+'|'+dbo.diaNombre(a.Fecha)+'|'+
Convert(varchar,a.PersonalId)+'|'+
(((SUBSTRING(p.PersonalNombres+' ',1,CHARINDEX(' ',p.PersonalNombres+' ')-1)))+' '+ ((SUBSTRING(p.PersonalApellidos+' ',1,CHARINDEX(' ',p.PersonalApellidos+' ')-1))))+'|'+
isnull(SUBSTRING(convert(varchar,a.HoraIngreso,114),1,8),'')+'|'+
isnull(SUBSTRING(convert(varchar,a.SalidaRefrigerio,114),1,8),'')+'|'+
isnull(SUBSTRING(convert(varchar,a.IngresoRefrigerio,114),1,8),'')+'|'+
isnull(SUBSTRING(convert(varchar,a.HoraSalida,114),1,8),'')+'|'+
Convert(varchar,a.NroMarcacion)+'|'+case when(convert(time,a.HoraIngreso) > p.HoraIngreso) then
'T' else 'A' end+'|'+
case when (convert(time,a.IngresoRefrigerio) > DATEADD(minute,60,(convert(time,a.SalidaRefrigerio)))) then
'T' else 'A' end
from Asistencia a
inner join Personal p
on p.PersonalId=a.PersonalId
where Convert(char(10),a.Fecha,103) BETWEEN @fechainicio AND @fechafin
order by a.Fecha asc
for XMl path('')),1,1,'')),'~')
End
GO
/****** Object:  StoredProcedure [dbo].[uspAsistenciaInsertaCsv]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspAsistenciaInsertaCsv]
@PersonalId int
as
Begin
Declare @dia int,@mes int,@anno int
set @dia=DAY(GETDATE())
set @mes=MONTH(GETDATE())
set @anno=YEAR(GETDATE())
Declare @Data varchar(max)
Declare @NroMarca int,
        @Id numeric(38)
Declare @p1 int,@p2 int
IF NOT EXISTS(select a.PersonalId  from Asistencia a
where a.PersonalId=@PersonalId and (Day(a.Fecha)=@dia and
MONTH(a.Fecha)=@mes and YEAR(a.Fecha)=@anno))
begin
insert into Asistencia values(GETDATE(),@PersonalId,GETDATE(),null,null,null,1,'')
Select 'true'
end
else
set @Data=((select convert(varchar,a.Id)+'|'+convert(varchar,a.NroMarcacion) 
from Asistencia a
where a.PersonalId=@PersonalId and (Day(a.Fecha)=@dia and
MONTH(a.Fecha)=@mes and YEAR(a.Fecha)=@anno)))
Set @Data = LTRIM(RTrim(@Data))
Set @p1 = CharIndex('|',@Data,0)
Set @p2 = Len(@Data)+1
Set @Id=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))
Set @NroMarca=convert(numeric(20),SUBSTRING(@Data,@p1+1,@p2-@p1-1))
if(@NroMarca=1)
begin
update Asistencia
set SalidaRefrigerio=GETDATE(),NroMarcacion=2
where Id=@Id
select 'R1'
end
else if(@NroMarca=2)
begin
update Asistencia
set IngresoRefrigerio=GETDATE(),NroMarcacion=3
where Id=@Id
select 'R2'
end
else if(@NroMarca=3)
begin
update Asistencia
set HoraSalida=GETDATE(),NroMarcacion=4
where Id=@Id
select 'S'
end
else
begin
select 'completo'
end
End
GO
/****** Object:  StoredProcedure [dbo].[uspAsistenciaListaCsv]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uspAsistenciaListaCsv]
as
Begin
select 
'Id|Fecha|PersonalId|Nombres|HoraIngreso|IngresoRefrigerio|RetornoRefrigerio|HoraSalida|NroMar|HoraING|HoraREF¬90|100|100|220|125|125|125|125|70|90|90¬String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+Convert(varchar,a.Id)+'|'+
convert(varchar,a.Fecha,103)+'|'+
Convert(varchar,a.PersonalId)+'|'+
(((SUBSTRING(p.PersonalNombres+' ',1,CHARINDEX(' ',p.PersonalNombres+' ')-1)))+' '+ ((SUBSTRING(p.PersonalApellidos+' ',1,CHARINDEX(' ',p.PersonalApellidos+' ')-1))))+'|'+
isnull(SUBSTRING(convert(varchar,a.HoraIngreso,114),1,8),'')+'|'+
isnull(SUBSTRING(convert(varchar,a.SalidaRefrigerio,114),1,8),'')+'|'+
isnull(SUBSTRING(convert(varchar,a.IngresoRefrigerio,114),1,8),''),''+'|'+
isnull(SUBSTRING(convert(varchar,a.HoraSalida,114),1,8),'')+'|'+
Convert(varchar,a.NroMarcacion)+'|'+case when(convert(time,a.HoraIngreso) > p.HoraIngreso) then
'T' else 'A' end+'|'+
case when (convert(time,a.IngresoRefrigerio) > DATEADD(minute,60,(convert(time,a.SalidaRefrigerio)))) then
'T' else 'A' end
from Asistencia a
inner join Personal p
on p.PersonalId=a.PersonalId
where DAY(a.Fecha)=DAY(GETDATE())and Month(a.Fecha)=Month(GETDATE())and year(a.Fecha)=YEAR(Getdate())
order by a.Id desc
for XMl path('')),1,1,'')),'~')
End
GO
/****** Object:  StoredProcedure [dbo].[uspAsistenciaPersonal]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uspAsistenciaPersonal]
@Id numeric(20),
@fechainicio date,
@fechafin date
as
Begin
select 
'Id|Fecha|Dia|PersonalId|Nombres|HoraIngreso|IngresoRefrigerio|RetornoRefrigerio|HoraSalida|NroMar|HoraING|HoraREF¬90|100|100|100|220|125|125|125|125|70|90|90¬String|String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+Convert(varchar,a.Id)+'|'+
convert(varchar,a.Fecha,103)+'|'+dbo.diaNombre(a.Fecha)+'|'+
Convert(varchar,a.PersonalId)+'|'+
(((SUBSTRING(p.PersonalNombres+' ',1,CHARINDEX(' ',p.PersonalNombres+' ')-1)))+' '+ ((SUBSTRING(p.PersonalApellidos+' ',1,CHARINDEX(' ',p.PersonalApellidos+' ')-1))))+'|'+
isnull(SUBSTRING(convert(varchar,a.HoraIngreso,114),1,8),'')+'|'+
isnull(SUBSTRING(convert(varchar,a.SalidaRefrigerio,114),1,8),'')+'|'+
isnull(SUBSTRING(convert(varchar,a.IngresoRefrigerio,114),1,8),'')+'|'+
isnull(SUBSTRING(convert(varchar,a.HoraSalida,114),1,8),'')+'|'+
Convert(varchar,a.NroMarcacion)+'|'+case when(convert(time,a.HoraIngreso) > p.HoraIngreso) then
'T' else 'A' end+'|'+
case when (convert(time,a.IngresoRefrigerio) > DATEADD(minute,60,(convert(time,a.SalidaRefrigerio)))) then
'T' else 'A' end
from Asistencia a
inner join Personal p
on p.PersonalId=a.PersonalId
where a.PersonalId=@Id and (Convert(char(10),a.Fecha,103) BETWEEN @fechainicio AND @fechafin)
order by a.Fecha asc
for XMl path('')),1,1,'')),'~')
End
GO
/****** Object:  StoredProcedure [dbo].[uspCajaInsertaCsv]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspCajaInsertaCsv]
@Data varchar(max)
as
Begin
Declare @p1 int,@p2 int,@p3 int,
        @p4 int,@p5 int,@p6 int,
        @p7 int,@p8 int,@p9 int,
        @p10 int,@p11 int
Declare @CajaId  numeric(38),@CajaCierre  varchar(40),
        @MontoIniSOl  decimal(18,2),@CajaEncargado  varchar(60),
        @CajaUsuario  varchar(60),@CajaEstado  varchar(40),
        @CajaIngresos  decimal(18,2),@CajaDeposito decimal(18,2),
        @CajaSalidas  decimal(18,2),@CajaTotal  decimal(18,2),
        @UsuarioId  int
Set @Data = LTRIM(RTrim(@Data))
Set @p1 = CharIndex('|',@Data,0)
Set @p2=CharIndex('|',@Data,@p1+1)
Set @p3=CharIndex('|',@Data,@p2+1)
Set @p4=CharIndex('|',@Data,@p3+1)
Set @p5=CharIndex('|',@Data,@p4+1)
Set @p6=CharIndex('|',@Data,@p5+1)
Set @p7=CharIndex('|',@Data,@p6+1)
Set @p8=CharIndex('|',@Data,@p7+1)
Set @p9=CharIndex('|',@Data,@p8+1)
Set @p10=CharIndex('|',@Data,@p9+1)
Set @p11= Len(@Data)+1
Set @CajaId=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))
Set @CajaCierre=SUBSTRING(@Data,@p1+1,@p2-@p1-1)
Set @MontoIniSOl=convert(decimal(18,2),SUBSTRING(@Data,@p2+1,@p3-@p2-1))
Set @CajaEncargado=SUBSTRING(@Data,@p3+1,@p4-@p3-1)
Set @CajaUsuario=SUBSTRING(@Data,@p4+1,@p5-@p4-1)
Set @CajaEstado=SUBSTRING(@Data,@p5+1,@p6-@p5-1)
Set @CajaIngresos=convert(decimal(18,2),SUBSTRING(@Data,@p6+1,@p7-@p6-1))
Set @CajaDeposito=convert(decimal(18,2),SUBSTRING(@Data,@p7+1,@p8-@p7-1))
Set @CajaSalidas=convert(decimal(18,2),SUBSTRING(@Data,@p8+1,@p9-@p8-1))
Set @CajaTotal=convert(decimal(18,2),SUBSTRING(@Data,@p9+1,@p10-@p9-1))
Set @UsuarioId=convert(int,SUBSTRING(@Data,@p10+1,@p11-@p10-1))
if(@CajaId=0)
begin
IF EXISTS(select top 1 CajaId from Caja 
where CajaEstado='ACTIVO' and UsuarioId=@UsuarioId order by 1 desc)
begin
select 'existe'
end
else
begin
insert into Caja values(GETDATE(),@CajaCierre,@MontoIniSOl,
@CajaEncargado,@CajaUsuario,@CajaEstado,@CajaIngresos,@CajaDeposito,
@CajaSalidas,@CajaTotal,@UsuarioId)
Select 'true'
end
end
else
begin
update Caja
set CajaCierre=@CajaCierre,MontoIniSOl=@MontoIniSOl,
CajaEncargado=@CajaEncargado,CajaUsuario=@CajaUsuario,
CajaEstado=@CajaEstado,CajaIngresos=@CajaIngresos,CajaDeposito=@CajaDeposito,
CajaSalidas=@CajaSalidas,CajaTotal=@CajaTotal,UsuarioId=@UsuarioId
where CajaId=@CajaId
Select 'true'
end
End
GO
/****** Object:  StoredProcedure [dbo].[uspComboMesas]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[uspComboMesas]
as
begin
select o.IdOrden as ID,
case when (o.NroMesas='')then
'PARA LLEVAR'
else
o.NroMesas end as Mesas
from Tbl_Orden_Pedido o
where o.Estado='REGISTRADO' and o.Estado<>'ANULADO'
order by o.IdOrden asc
end
GO
/****** Object:  StoredProcedure [dbo].[uspCuentaProve]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspCuentaProve]
@ProveedorId numeric(38)
as
select 
'Id|EntidadBancaria|TipoCuenta|Moneda|NroCuenta¬100|250|140|95|250¬String|String|String|String|String¬'+
isnull((select STUFF ((select '¬'+ CONVERT(varchar,c.CuentaId)+'|'+c.Entidad+'|'+
c.TipoCuenta+'|'+c.Moneda+'|'+c.NroCuenta
from CuentaProveedor c
where c.ProveedorId=@ProveedorId
order by c.CuentaId desc
for xml path('')),1,1,'')),'~')
GO
/****** Object:  StoredProcedure [dbo].[uspDesanular]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uspDesanular]
@ListaOrden varchar(Max)
as
begin
Declare @pos int
Declare @orden varchar(max)
Declare @detalle varchar(max)
Set @pos = CharIndex('[',@ListaOrden,0)
Set @orden = SUBSTRING(@ListaOrden,1,@pos-1)
Set @detalle = SUBSTRING(@ListaOrden,@pos+1,len(@ListaOrden)-@pos)
Declare @p1 int,@p2 int,
        @p3 int,@p4 int,
        @p5 int
Declare @DocuId numeric(38),
@NotaId numeric(38),@Usuario varchar(40),
@Estado varchar(40),@CajaId numeric(38),
@Total decimal(18,2),@Documento varchar(40)
Set @orden = LTRIM(RTrim(@orden))
Set @p1 = CharIndex('|',@orden,0)
Set @p2 = CharIndex('|',@orden,@p1+1)
Set @p3 = CharIndex('|',@orden,@p2+1)
set @p4=CharIndex('|',@orden,@p3+1)
Set @p5=Len(@orden)+1
Set @DocuId=convert(numeric(38),SUBSTRING(@orden,1,@p1-1))
Set @NotaId=convert(numeric(38),SUBSTRING(@orden,@p1+1,@p2-@p1-1))
Set @Usuario=SUBSTRING(@orden,@p2+1,@p3-@p2-1)
Set @Total=convert(decimal(18,2),SUBSTRING(@orden,@p3+1,@p4-@p3-1))
Set @Documento=SUBSTRING(@orden,@p4+1,@p5-@p4-1)
set @CajaId=isnull((select top 1 CajaId from Caja where CajaEstado='ACTIVO' 
and CajaEncargado=@Usuario order by 1 desc),'0')
Begin Transaction
update DocumentoVenta
set DocuUsuario=@Usuario,DocuEstado='EMITIDO'
where DocuId=@DocuId
update NotaPedido
set NotaUsuario=@Usuario,NotaEstado='CANCELADO',NotaAcuenta=@Total,
NotaSaldo=0
Where NotaId=@NotaId
if(@CajaId<>0)
begin
insert into CajaDetalle values(@CajaId,GETDATE(),@NotaId,'INGRESO','',
'','SOLES',0,@Total,@Total,0)
end
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
Declare @Columna varchar(max),
		@IdProducto numeric(20),
		@Cantidad decimal(18,2),
		@Precio decimal(18,2),
		@IniciaStock decimal(18,2),
		@StockFinal decimal(18,2)
Declare @d1 int,@d2 int,@d3 int
Fetch Next From Tabla INTO @Columna
	While @@FETCH_STATUS = 0
	Begin
Set @d1 = CharIndex('|',@Columna,0)
Set @d2 = CharIndex('|',@Columna,@d1+1)
Set @d3 = Len(@Columna)+1
Set @IdProducto=Convert(numeric(38),SUBSTRING(@Columna,1,@d1-1))
Set @Cantidad=Convert(decimal(18,2),SUBSTRING(@Columna,@d1+1,@d2-(@d1+1)))
Set @Precio=Convert(decimal(18,2),SUBSTRING(@Columna,@d2+1,@d3-(@d2+1)))
	set @IniciaStock=(select top 1 ProductoCantidad from Producto where IdProducto=@IdProducto)
	set @StockFinal=@IniciaStock-@Cantidad
    insert into Kardex values(@IdProducto,GETDATE(),'Salida por DesaAnulacion',@Documento,@IniciaStock,
	0,@Cantidad,@Precio,@StockFinal,'SALIDA',@Usuario)
	update producto 
	set  ProductoCantidad =ProductoCantidad - @Cantidad
	where IDProducto=@IdProducto
Fetch Next From Tabla INTO @Columna
end
	Close Tabla;
	Deallocate Tabla;
	Commit Transaction;
select 'true'
end
GO
/****** Object:  StoredProcedure [dbo].[uspDescontinuados]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspDescontinuados]  
as  
begin  
select   
'IdProducto|Codigo|Descripcion|Cantidad|UM|PrecioVenta|PrecioVentaB|Costo|Estado|Usuario|Imagen¬100|120|370|100|85|100|100|100|130|160|100¬String|String|String|String|String|String|String|String|String|String|String¬'+  
isnull((select STUFF((select '¬'+convert(varchar,p.IdProducto)+'|'+p.ProductoCodigo+'|'+  
p.ProductoNombre+'|'+convert(varchar(50),cast(p.ProductoCantidad as money),1)+'|'+   
p.ProductoUM+'|'+convert(varchar(50),cast(p.ProductoVenta as money),1)+'|'+  
convert(varchar(50),cast(p.ProductoVentaB as money),1)+'|'+convert(varchar,p.ProductoCosto)+'|'+  
p.ProductoEstado+'|'+p.ProductoUsuario+'|'+p.ProductoImagen  
FROM Producto p with(nolock)  
where p.ProductoEstado='DESCONTINUADO'  
order by p.IdProducto desc  
for xml path('')),1,1,'')),'~')  
end
GO
/****** Object:  StoredProcedure [dbo].[uspDescuento]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspDescuento]
@detalle varchar(Max)
as
begin
Begin Transaction
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
Declare @Columna varchar(max),
        @TemporalId numeric(38),
		@Descuento decimal(18,4)
Declare @p1 int,@p2 int
Fetch Next From Tabla INTO @Columna
	While @@FETCH_STATUS = 0
	Begin
Set @p1 = CharIndex('|',@Columna,0)
Set @p2 = Len(@Columna)+1
Set @TemporalId=Convert(numeric(38),SUBSTRING(@Columna,1,@p1-1))
Set @Descuento=Convert(decimal(18,4),SUBSTRING(@Columna,@p1+1,@p2-(@p1+1)))
update TemporalCompra 
set DetalleDescuento=@Descuento 
where TemporalId=@TemporalId		
Fetch Next From Tabla INTO @Columna
end
	Close Tabla;
	Deallocate Tabla;
	Commit Transaction;
select 'true'
end
GO
/****** Object:  StoredProcedure [dbo].[uspDescuentoB]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspDescuentoB]
@detalle varchar(Max)
as
begin
Begin Transaction
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
Declare @Columna varchar(max),
        @DetalleId numeric(38),
		@Descuento decimal(18,4)
Declare @p1 int,@p2 int
Fetch Next From Tabla INTO @Columna
	While @@FETCH_STATUS = 0
	Begin
Set @p1 = CharIndex('|',@Columna,0)
Set @p2 = Len(@Columna)+1
Set @DetalleId=Convert(numeric(38),SUBSTRING(@Columna,1,@p1-1))
Set @Descuento=Convert(decimal(18,4),SUBSTRING(@Columna,@p1+1,@p2-(@p1+1)))
update DetalleCompra 
set DetalleDescuento=@Descuento
where DetalleId=@DetalleId	
Fetch Next From Tabla INTO @Columna
end
	Close Tabla;
	Deallocate Tabla;
	Commit Transaction;
select 'true'
end
GO
/****** Object:  StoredProcedure [dbo].[uspDetalleEliminarCsv]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[uspDetalleEliminarCsv]
@DetalleId numeric(38)
As
Begin
	Delete From Tbl_Detalle_Orden
	Where DetalleId=@DetalleId	
	Select 'true'
End
GO
/****** Object:  StoredProcedure [dbo].[uspDetalleNC]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspDetalleNC]  
@Data varchar(max)   
as  
begin

Declare @DocuId numeric(38),
        @IGV decimal(18,2)   
Declare @p1 int,@p2 int   
Set @Data = LTRIM(RTrim(@Data))    
Set @p1 = CharIndex('|',@Data,0) 
Set @p2= Len(@Data)+1    
Set @DocuId=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))    
Set @IGV=convert(decimal(18,2),SUBSTRING(@Data,@p1+1,@p2-@p1-1))

Declare @IgvD decimal(18,2),@IgvR decimal(18,2)

set @IgvR=(@IGV/100)
set @IgvD=@IgvR+1

select  
'Cantidad|UM|Descripcion|Precio|Importe|DetalleId|IdProducto|valorUM|PrecioSunat|IGVPrecio|ImporteSunat|Codigo¬103|100|350|110|115|100|100|100|100|100|100|100¬String|String|String|String|String|String|String|String|String|String|String|String¬'+  
isnull((select STUFF((select '¬'+CONVERT(VarChar(50), cast(d.DetalleCantidad as money ), 1)+'|'+  
d.DetalleUM+'|'+p.ProductoNombre+'|'+  
CONVERT(VarChar(50), cast(d.DetallPrecio as money ), 1)+'|'+  
CONVERT(VarChar(50), cast(d.DetalleImporte as money ), 1)+'|'+  
convert(varchar,d.DetalleNotaId)+'|'+convert(varchar,d.IdProducto)+'|'+  
convert(varchar,d.ValorUM)+'|'+  
convert(varchar,convert(decimal(18,6),d.DetallPrecio/@IgvD))+'|'+  
convert(varchar,(d.DetalleImporte - convert(decimal(18,6),d.DetalleImporte/@IgvD)))+'|'+  
convert(varchar,convert(decimal(18,6),d.DetalleImporte/@IgvD))+'|'+  
P.ProductoCodigo  
from DetalleDocumento d  
inner join Producto p  
on p.IdProducto=d.IdProducto  
where DocuId=@DocuId  
order by d.DetalleId asc  
for xml path('')),1,1,'')),'~')  
end
GO
/****** Object:  StoredProcedure [dbo].[uspEditaBonificacion]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspEditaBonificacion]
@Data varchar(max)
as
begin
Declare @p1 int
Declare @p2 int
Declare @p3 int
declare @TemporalId numeric(38),
@Estado varchar(20),
@UsuarioID int
Set @Data = LTRIM(RTrim(@Data))
Set @p1 = CharIndex('|',@Data,0)
Set @p2 = CharIndex('|',@Data,@p1+1)
Set @p3 =Len(@Data)+1
Set @TemporalId =convert(numeric(38),SUBSTRING(@Data,1,@p1-1))
Set @Estado=SUBSTRING(@Data,@p1+1,@p2-@p1-1)
Set @UsuarioID=convert(int,SUBSTRING(@Data,@p2+1,@p3-@p2-1))
update TemporalCompra 
set PrecioCosto=0,DetalleImporte=0,DetalleDescuento=0,
DetalleEstado=@Estado 
where TemporalId=@TemporalId
select
isnull((select STUFF ((select '¬'+convert(varchar,t.TemporalId)+'|'+convert(varchar,t.IdProducto)+'|'+
t.DetalleCodigo+'|'+t.Descripcion+'|'+t.DetalleUM+'|'+
CONVERT(VarChar(50),cast(t.DetalleCantidad as money ), 1)+'|'+
convert(varchar,t.PrecioCosto)+'|'+convert(varchar,t.DetalleDescuento)
+'|'+convert(varchar,t.DetalleImporte)+'|'+CONVERT(varchar,t.ValorUM)+'|'+
t.DetalleEstado
from TemporalCompra t 
inner join Producto p 
on p.IdProducto=t.IdProducto 
where t.UsuarioID=@UsuarioID
order by t.TemporalId asc
for xml path('')),1,1,'')),'~')+'['+
isnull((select STUFF ((select '¬'+convert(varchar,u.IdUm)+'|'+convert(varchar,u.IdProducto)+'|'+
u.UMDescripcion+'|'+CONVERT(VarChar(50), cast(u.ValorUM as money ), 1)+'|'+
convert(varchar,t.PrecioCosto)
from UnidadMedida u
inner join TemporalCompra t
on t.IdProducto=u.IdProducto
where t.UsuarioID=@UsuarioID
order by u.ValorUM asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspEditaDocNro]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspEditaDocNro]
@Data varchar(max)
as
begin
Declare @p1 int,@p2 int,@p3 int,@p4 int
Declare @DocuId numeric(38),@DocuNumero varchar(80),
@DocuEmision date,@DocuUsuario varchar(80)
Set @Data = LTRIM(RTrim(@Data))
Set @p1 = CharIndex('|',@Data,0)
Set @p2 = CharIndex('|',@Data,@p1+1)
Set @p3 = CharIndex('|',@Data,@p2+1)  
Set @p4 = Len(@Data)+1 
Set @DocuId=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))
Set @DocuNumero=SUBSTRING(@Data,@p1+1,@p2-@p1-1) 
Set @DocuEmision=convert(date,SUBSTRING(@Data,@p2+1,@p3-@p2-1))
Set @DocuUsuario=SUBSTRING(@Data,@p3+1,@p4-@p3-1)
update DocumentoVenta
set DocuNumero=@DocuNumero,DocuEmision=@DocuEmision,
DocuUsuario=@DocuUsuario
where DocuId=@DocuId
select 'true'
end
GO
/****** Object:  StoredProcedure [dbo].[uspEditaDocu]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspEditaDocu]
@Data varchar(max)
as
begin
Declare @pos1 int
Declare @pos2 int
declare @pos3 int
declare @pos4 int
Declare @DocuId numeric(38),
@Numero varchar(40),
@DocuEmision date,
@Usuario varchar(40)
Set @Data = LTRIM(RTrim(@Data))
Set @pos1 = CharIndex('|',@Data,0)
Set @DocuId=convert(numeric(38),SUBSTRING(@Data,1,@pos1-1))
Set @pos2 = CharIndex('|',@Data,@pos1+1)
Set @Numero=SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1)
Set @pos3= CharIndex('|',@Data,@pos2+1)
Set @DocuEmision=convert(date,SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1))
Set @pos4= Len(@Data)+1
Set @Usuario=SUBSTRING(@Data,@pos3+1,@pos4-@pos3-1)
update DocumentoVenta
set DocuNumero=@Numero,DocuEmision=@DocuEmision,DocuUsuario=@Usuario
where DocuId=@DocuId
select 'true'
end
GO
/****** Object:  StoredProcedure [dbo].[uspEditarInventario]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspEditarInventario]    
@ListaOrden varchar(Max)    
as    
begin    
Declare @detalle varchar(max)    
Set @detalle =@ListaOrden    
Begin Transaction    
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')     
Open Tabla    
        Declare @Columna varchar(max)    
  declare @IdProducto numeric(20),    
  @Cantidad decimal(18,2),    
     @Costo decimal(18,4),    
     @Usuario varchar(80),    
     @StockInicial decimal(18,2)    
  declare @p1 int,@p2 int,    
  @p3 int,@p4 int    
Fetch Next From Tabla INTO @Columna    
While @@FETCH_STATUS = 0    
Begin    
     Set @p1 = CharIndex('|',@Columna,0)    
     Set @p2 = CharIndex('|',@Columna,@p1+1)    
     Set @p3 = CharIndex('|',@Columna,@p2+1)    
  Set @p4 =Len(@Columna)+1    
        Set @IdProducto=Convert(numeric(20),SUBSTRING(@Columna,1,@p1-1))    
  Set @Cantidad=Convert(decimal(18,2),SUBSTRING(@Columna,@p1+1,@p2-(@p1+1)))    
  Set @Costo=Convert(decimal(18,4),SUBSTRING(@Columna,@p2+1,@p3-(@p2+1)))    
  Set @Usuario=SUBSTRING(@Columna,@p3+1,@p4-(@p3+1))    
  set @StockInicial=(select top 1 p.ProductoCantidad     
  from Producto p    
  where IdProducto=@IdProducto)    
  insert into Kardex values(@IdProducto,GETDATE(),'EDITA INVENTARIO','EDITA INVENTARIO',    
  @StockInicial,0,0,@Costo,@Cantidad,'INGRESO',@Usuario)      
  update Producto    
  set ProductoCantidad=@Cantidad    
  where IdProducto=@IdProducto      
Fetch Next From Tabla INTO @Columna    
END    
 Close Tabla;    
 Deallocate Tabla;    
 Commit Transaction;    
 Select 'true';    
end
GO
/****** Object:  StoredProcedure [dbo].[uspEditarNotaB]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspEditarNotaB]  
@ListaOrden varchar(Max)  
as  
begin  
Declare @pos1 int,@pos2 int  
Declare @orden varchar(max),  
        @detalle varchar(max)  
Set @pos1 = CharIndex('[',@ListaOrden,0)  
Set @pos2 =Len(@ListaOrden)+1  
Set @orden = SUBSTRING(@ListaOrden,1,@pos1-1)  
Set @detalle = SUBSTRING(@ListaOrden,@pos1+1,@pos2-@pos1-1)  
Declare @c1 int,@c2 int,@c3 int,@c4 int,  
        @c5 int,@c6 int,@c7 int,@c8 int,  
        @c9 int,@c10 int,@c11 int,@c12 int,  
        @c13 int,@c14 int,@c15 int,@c16 int,  
        @c17 int,@c18 int,@c19 int,@c20 int,  
        @c21 int,@c22 int,@c23 int,@c24 int,  
        @c25 int,@c26 int,@c27 int,@c28 int,  
        @c29 int,@c30 int,@c31 int,@c32 int,  
        @c33 int,@c34 int,@c35 int,@c36 int  
Declare   
  @NotaDocu varchar(60),@ClienteId numeric(20),  
  @NotaUsuario varchar(60),@NotaFormaPago varchar(60),  
  @NotaCondicion varchar(60),@NotaDireccion varchar(max),  
  @NotaTelefono varchar(60),@NotaSubtotal decimal (18,2),  
  @NotaMovilidad decimal(18,2),@NotaDescuento decimal (18, 2),  
  @NotaTotal decimal (18,2),@NotaAcuenta decimal(18,2),  
  @NotaSaldo decimal(18,2),@NotaAdicional decimal(18,2),  
  @NotaTarjeta decimal(18,2),@NotaPagar decimal(18,2),  
  @NotaEstado varchar(60),@CompaniaId int,  
  @NotaEntrega varchar(40),@NotaConcepto varchar(60),  
  @Serie char(4),@Numero varchar(60),  
  @NotaGanancia decimal(18,2),@Letra varchar(max),  
  @DocuAdicional decimal(18,2),@DocuHash varchar(250),  
  @EstadoSunat varchar(80),@DocuSubtotal decimal(18,2),  
  @DocuIGV decimal(18,2),@UsuarioId int,@NotaId numeric(38),  
  @CajaId numeric(38),@Movimiento varchar(40),  
  @KARDEX VARCHAR(1),@Efectivo decimal(18,2),@Vuelto decimal(18,2),  
  @ICBPER decimal(18,2),@DocuGravada decimal(18,2),@DocuDescuento decimal(18,2)  
Set @c1 = CharIndex('|',@orden,0)  
Set @c2 = CharIndex('|',@orden,@c1+1)  
Set @c3 = CharIndex('|',@orden,@c2+1)  
Set @c4 = CharIndex('|',@orden,@c3+1)  
Set @c5 = CharIndex('|',@orden,@c4+1)  
Set @c6= CharIndex('|',@orden,@c5+1)  
Set @c7 = CharIndex('|',@orden,@c6+1)  
Set @c8 = CharIndex('|',@orden,@c7+1)  
Set @c9 = CharIndex('|',@orden,@c8+1)  
Set @c10= CharIndex('|',@orden,@c9+1)  
Set @c11= CharIndex('|',@orden,@c10+1)  
Set @c12= CharIndex('|',@orden,@c11+1)  
Set @c13= CharIndex('|',@orden,@c12+1)  
Set @c14= CharIndex('|',@orden,@c13+1)  
Set @c15= CharIndex('|',@orden,@c14+1)  
Set @c16= CharIndex('|',@orden,@c15+1)  
Set @c17= CharIndex('|',@orden,@c16+1)  
Set @c18 = CharIndex('|',@orden,@c17+1)  
Set @c19 = CharIndex('|',@orden,@c18+1)  
Set @c20= CharIndex('|',@orden,@c19+1)  
Set @c21= CharIndex('|',@orden,@c20+1)  
Set @c22= CharIndex('|',@orden,@c21+1)  
Set @c23= CharIndex('|',@orden,@c22+1)  
Set @c24= CharIndex('|',@orden,@c23+1)  
Set @c25= CharIndex('|',@orden,@c24+1)  
Set @c26= CharIndex('|',@orden,@c25+1)  
Set @c27= CharIndex('|',@orden,@c26+1)  
Set @c28= CharIndex('|',@orden,@c27+1)  
Set @c29= CharIndex('|',@orden,@c28+1)  
Set @c30= CharIndex('|',@orden,@c29+1)  
Set @c31= CharIndex('|',@orden,@c30+1)  
Set @c32= CharIndex('|',@orden,@c31+1)  
Set @c33= CharIndex('|',@orden,@c32+1)  
Set @c34= CharIndex('|',@orden,@c33+1)  
Set @c35= CharIndex('|',@orden,@c34+1)  
Set @c36= Len(@orden)+1  
set @NotaDocu=SUBSTRING(@orden,1,@c1-1)  
set @ClienteId=convert(numeric(20),SUBSTRING(@orden,@c1+1,@c2-@c1-1))  
set @NotaUsuario=SUBSTRING(@orden,@c2+1,@c3-@c2-1)  
set @NotaFormaPago=SUBSTRING(@orden,@c3+1,@c4-@c3-1)  
set @NotaCondicion=SUBSTRING(@orden,@c4+1,@c5-@c4-1)  
set @NotaDireccion=SUBSTRING(@orden,@c5+1,@c6-@c5-1)  
set @NotaTelefono=SUBSTRING(@orden,@c6+1,@c7-@c6-1)  
set @NotaSubtotal=convert(decimal(18,2),SUBSTRING(@orden,@c7+1,@c8-@c7-1))  
set @NotaMovilidad=convert(decimal(18,2),SUBSTRING(@orden,@c8+1,@c9-@c8-1))  
set @NotaDescuento=convert(decimal(18,2),SUBSTRING(@orden,@c9+1,@c10-@c9-1))  
set @NotaTotal=convert(decimal(18,2),SUBSTRING(@orden,@c10+1,@c11-@c10-1))  
set @NotaAcuenta=convert(decimal(18,2),SUBSTRING(@orden,@c11+1,@c12-@c11-1))  
set @NotaSaldo=convert(decimal(18,2),SUBSTRING(@orden,@c12+1,@c13-@c12-1))  
set @NotaAdicional=convert(decimal(18,2),SUBSTRING(@orden,@c13+1,@c14-@c13-1))  
set @NotaTarjeta=convert(decimal(18,2),SUBSTRING(@orden,@c14+1,@c15-@c14-1))  
set @NotaPagar=convert(decimal(18,2),SUBSTRING(@orden,@c15+1,@c16-@c15-1))  
set @NotaEstado=SUBSTRING(@orden,@c16+1,@c17-@c16-1)  
set @CompaniaId=convert(int,SUBSTRING(@orden,@c17+1,@c18-@c17-1))  
set @NotaEntrega=SUBSTRING(@orden,@c18+1,@c19-@c18-1)  
set @NotaConcepto=SUBSTRING(@orden,@c19+1,@c20-@c19-1)  
set @Serie=convert(char(4),SUBSTRING(@orden,@c20+1,@c21-@c20-1))  
set @Numero=SUBSTRING(@orden,@c21+1,@c22-@c21-1)  
set @NotaGanancia=convert(decimal(18,2),SUBSTRING(@orden,@c22+1,@c23-@c22-1))  
set @Letra=SUBSTRING(@orden,@c23+1,@c24-@c23-1)  
set @DocuAdicional=convert(decimal(18,2),SUBSTRING(@orden,@c24+1,@c25-@c24-1))  
set @DocuHash=SUBSTRING(@orden,@c25+1,@c26-@c25-1)  
set @EstadoSunat=SUBSTRING(@orden,@c26+1,@c27-@c26-1)  
set @DocuSubtotal=convert(decimal(18,2),SUBSTRING(@orden,@c27+1,@c28-@c27-1))  
set @DocuIGV=convert(decimal(18,2),SUBSTRING(@orden,@c28+1,@c29-@c28-1))  
set @UsuarioId=convert(int,SUBSTRING(@orden,@c29+1,@c30-@c29-1))  
set @NotaId=convert(numeric(38),SUBSTRING(@orden,@c30+1,@c31-@c30-1))  
set @Efectivo=convert(decimal(18,2),SUBSTRING(@orden,@c31+1,@c32-@c31-1))  
set @Vuelto=convert(decimal(18,2),SUBSTRING(@orden,@c32+1,@c33-@c32-1))  
set @ICBPER=convert(decimal(18,2),SUBSTRING(@orden,@c33+1,@c34-@c33-1))  
set @DocuGravada=convert(decimal(18,2),SUBSTRING(@orden,@c34+1,@c35-@c34-1))  
set @DocuDescuento=convert(decimal(18,2),SUBSTRING(@orden,@c35+1,@c36-@c35-1))  
set @CajaId=isnull((select top 1 CajaId from Caja where CajaEstado='ACTIVO'   
and UsuarioId=@UsuarioId order by 1 desc),'0')  
if(@CajaId=0)  
begin  
select 'false'  
end  
else  
begin  
if(@NotaDocu='FACTURA')set @NotaEstado='PENDIENTE'  
else if(@NotaDocu='PROFORMA')set @NotaEstado='PENDIENTE'  
else  
begin  
   set @NotaEstado='CANCELADO'  
   set @NotaSaldo=0  
   set @NotaAcuenta=@NotaPagar  
end  
if(@NotaFormaPago='EFECTIVO')set @Movimiento='INGRESO'  
else set @Movimiento='TARJETA'   
declare @DocuId numeric(38)=0  
Begin Transaction  
update Cliente  
set ClienteDireccion=@NotaDireccion,  
ClienteTelefono=@NotaTelefono  
where ClienteId=@ClienteId  
delete from TemporalVenta   
where UsuarioID=@UsuarioId  
declare @cod varchar(13)  
SET @cod=isnull((select TOP 1 dbo.genenerarNroFactura(@Serie,@CompaniaId,@NotaDocu) AS ID   
FROM DocumentoVenta),'00000001')  
update NotaPedido  
set NotaDocu=@NotaDocu,  
ClienteId=@ClienteId,  
FechaEdita=(IsNull(convert(varchar,GETDATE(),103),'')+' '+ IsNull(SUBSTRING(convert(varchar,GETDATE(),114),1,8),'')),  
NotaUsuario=@NotaUsuario,  
NotaFormaPago=@NotaFormaPago,  
NotaCondicion=@NotaCondicion,  
NotaDireccion=@NotaDireccion,  
NotaTelefono=@NotaTelefono,  
NotaSubtotal=@NotaSubtotal,  
NotaMovilidad=@NotaMovilidad,  
NotaDescuento=@NotaDescuento,  
NotaTotal=@NotaTotal,  
NotaSaldo=@NotaSaldo,  
NotaAdicional=@NotaAdicional,  
NotaTarjeta=@NotaTarjeta,  
NotaPagar=@NotaPagar,  
CompaniaId=@CompaniaId,  
NotaEntrega=@NotaEntrega,  
ModificadoPor=@NotaUsuario,  
NotaSerie=@Serie,  
NotaNumero=@cod,  
NotaGanancia=@NotaGanancia,  
NotaEstado=@NotaEstado,  
NotaConcepto=@NotaConcepto,  
CajaId=@CajaId,  
NotaEfectivo=@Efectivo,  
NotaVuelto=@Vuelto  
where NotaId=@NotaId  
if @NotaDocu='PROFORMA V'  
begin  
insert into DocumentoVenta values  
(@CompaniaId,@NotaId,'PROFORMA V',@cod,@ClienteId,GETDATE(),  
GETDATE(),@NotaCondicion,cast(convert(date,GETDATE()) as varchar(10)),  
@Letra,@DocuSubtotal,@DocuIGV,@NotaPagar,0,@NotaUsuario,'EMITIDO',@Serie,'00',  
@DocuAdicional,'','VENTA','',@DocuHash,'ENVIADO','','',  
@ICBPER,@DocuGravada,@DocuDescuento)  
set @DocuId=(select @@IDENTITY)  
insert into CajaDetalle values(@CajaId,GETDATE(),@NotaId,@Movimiento,'',  
'Transacción con '+@NotaFormaPago,'SOLES',0,@NotaPagar,@Efectivo,@Vuelto)  
SET @KARDEX='S'  
end  
else if @NotaDocu='BOLETA'  
begin  
insert into DocumentoVenta values  
(@CompaniaId,@NotaId,'BOLETA',@cod,@ClienteId,GETDATE(),  
GETDATE(),@NotaCondicion,cast(convert(date,GETDATE()) as varchar(10)),  
@Letra,@DocuSubtotal,@DocuIGV,@NotaPagar,0,@NotaUsuario,'EMITIDO',@Serie,'03',  
@DocuAdicional,'','VENTA','',@DocuHash,@EstadoSunat,'','',  
@ICBPER,@DocuGravada,@DocuDescuento)  
set @DocuId=(select @@IDENTITY)  
if(@NotaConcepto='MERCADERIA')  
begin  
insert into CajaDetalle values(@CajaId,GETDATE(),@NotaId,@Movimiento,'',  
'Transacción con '+@NotaFormaPago,'SOLES',0,@NotaPagar,@Efectivo,@Vuelto)  
SET @KARDEX='S'  
end  
end  
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')   
Open Tabla  
Declare @Columna varchar(max),  
        @DetalleId numeric(38),  
  @IdProducto numeric(20),  
  @DetalleCantidad decimal(18,2),  
  @DetalleUm varchar(40),  
  @Descripcion varchar(max),  
  @DetalleCosto decimal(18,2),   
  @DetallePrecio decimal(18,2),  
  @DetalleImporte decimal(18,2),  
  @DetalleEstado varchar(60),  
  @ValorUM decimal(18,4),@CantidadSaldo decimal(18,2),  
  @IniciaStock decimal(18,2),@StockFinal decimal(18,2)  
Declare @p1 int,@p2 int,@p3 int,@p4 int,  
        @p5 int,@p6 int,@p7 int,@p8 int,  
        @p9 int,@p10 int  
Fetch Next From Tabla INTO @Columna  
 While @@FETCH_STATUS = 0  
 Begin  
Set @p1 = CharIndex('|',@Columna,0)  
Set @p2 = CharIndex('|',@Columna,@p1+1)  
Set @p3 = CharIndex('|',@Columna,@p2+1)  
Set @p4 = CharIndex('|',@Columna,@p3+1)  
Set @p5 = CharIndex('|',@Columna,@p4+1)  
Set @p6= CharIndex('|',@Columna,@p5+1)  
Set @p7= CharIndex('|',@Columna,@p6+1)  
Set @p8 = CharIndex('|',@Columna,@p7+1)  
Set @p9= CharIndex('|',@Columna,@p8+1)  
Set @p10=Len(@Columna)+1  
set @DetalleId=Convert(numeric(38),SUBSTRING(@Columna,1,@p1-1))  
set @IdProducto=Convert(numeric(20),SUBSTRING(@Columna,@p1+1,@p2-(@p1+1)))  
Set @DetalleCantidad=convert(decimal(18,2),SUBSTRING(@Columna,@p2+1,@p3-(@p2+1)))  
Set @DetalleUm=SUBSTRING(@Columna,@p3+1,@p4-(@p3+1))  
Set @Descripcion=SUBSTRING(@Columna,@p4+1,@p5-(@p4+1))  
Set @DetalleCosto=convert(decimal(18,2),SUBSTRING(@Columna,@p5+1,@p6-(@p5+1)))  
Set @DetallePrecio=convert(decimal(18,2),SUBSTRING(@Columna,@p6+1,@p7-(@p6+1)))  
Set @DetalleImporte=convert(decimal(18,2),SUBSTRING(@Columna,@p7+1,@p8-(@p7+1)))  
Set @DetalleEstado=SUBSTRING(@Columna,@p8+1,@p9-(@p8+1))  
set @ValorUM=convert(decimal(18,4),SUBSTRING(@Columna,@p9+1,@p10-(@p9+1)))  
if(@NotaEntrega='INMEDIATA')Set @CantidadSaldo=0  
else Set @CantidadSaldo=@DetalleCantidad  
update DetallePedido  
set DetalleCantidad=@DetalleCantidad,DetalleCosto=@DetalleCosto,  
DetallePrecio=@DetallePrecio,DetalleImporte=@DetalleImporte,  
DetalleEstado=@DetalleEstado  
where DetalleId=@DetalleId  
if(@DocuId<>0)  
begin  
insert into DetalleDocumento values  
(@DocuId,@IdProducto,@DetalleCantidad,@DetallePrecio,@DetalleImporte,  
@NotaId,@DetalleUm,@ValorUM)  
end  
if(@KARDEX='S')  
BEGIN
 
 set @DetalleCantidad =@DetalleCantidad * @ValorUM
 
 set @IniciaStock=(select top 1 ProductoCantidad from Producto where IdProducto=@IdProducto)  
 set @StockFinal=@IniciaStock-@DetalleCantidad
   
 insert into Kardex values(@IdProducto,GETDATE(),'Salida por Venta',@Serie+'-'+@cod,@IniciaStock,  
 0,@DetalleCantidad,@DetalleCosto,@StockFinal,'SALIDA',@NotaUsuario)  
 
 update producto   
 set  ProductoCantidad =ProductoCantidad - @DetalleCantidad  
 where IDProducto=@IdProducto  

end  
Fetch Next From Tabla INTO @Columna  
end  
 Close Tabla;  
 Deallocate Tabla;  
    Commit Transaction;  
    select @cod  
end  
end
GO
/****** Object:  StoredProcedure [dbo].[uspEditarRB]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspEditarRB]  
@Data varchar(max)  
as  
begin  
Declare  @p1 int,@p2 int,  
         @p3 int,@p4 int  
Declare  @ResumenId numeric(38),@CodigoSunat varchar(80),  
         @MensajeSunat varchar(max),@HASHCDR varchar(max)  
Set @Data = LTRIM(RTrim(@Data))  
Set @p1 = CharIndex('|',@Data,0)  
Set @p2 = CharIndex('|',@Data,@p1+1)  
Set @p3 = CharIndex('|',@Data,@p2+1)  
Set @p4= Len(@Data)+1  
Set @ResumenId=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))  
Set @CodigoSunat=SUBSTRING(@Data,@p1+1,@p2-@p1-1)  
Set @MensajeSunat=SUBSTRING(@Data,@p2+1,@p3-@p2-1)  
Set @HASHCDR=SUBSTRING(@Data,@p3+1,@p4-@p3-1)  
update ResumenBoletas  
set CodigoSunat=@CodigoSunat,MensajeSunat=@MensajeSunat,HASHCDR=@HASHCDR  
where ResumenId=@ResumenId  
SELECT 'true'  
end
GO
/****** Object:  StoredProcedure [dbo].[uspEditarTemporal]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspEditarTemporal]
@Data varchar(max)
as
begin
Declare @pos1 int
Declare @pos2 int
Declare @pos3 int
Declare @pos4 int
Declare @pos5 int
Declare @pos6 int
declare @Id numeric(38),
@cantidad decimal(18,2),
@precioCosto decimal(18,4),
@Descuento decimal(18,4),
@importe decimal(18,2),
@UsuarioID int
Set @Data = LTRIM(RTrim(@Data))
Set @pos1 = CharIndex('|',@Data,0)
Set @pos2 = CharIndex('|',@Data,@pos1+1)
Set @pos3 = CharIndex('|',@Data,@pos2+1)
Set @pos4 = CharIndex('|',@Data,@pos3+1)
Set @pos5= CharIndex('|',@Data,@pos4+1)
Set @pos6 =Len(@Data)+1
Set @Id =convert(numeric(38),SUBSTRING(@Data,1,@pos1-1))
Set @cantidad=convert(decimal(18,2),SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))
Set @precioCosto=convert(decimal(18,4),SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1))
Set @Descuento=convert(decimal(18,4),SUBSTRING(@Data,@pos3+1,@pos4-@pos3-1))
Set @importe=convert(decimal(18,4),SUBSTRING(@Data,@pos4+1,@pos5-@pos4-1))
Set @UsuarioID=convert(int,SUBSTRING(@Data,@pos5+1,@pos6-@pos5-1))
update TemporalCompra
set DetalleCantidad=@cantidad,PrecioCosto=@precioCosto,
DetalleDescuento=@Descuento,DetalleImporte=@importe
where TemporalId=@Id
select isnull((select STUFF ((select '¬'+convert(varchar,u.IdUm)+'|'+convert(varchar,u.IdProducto)+'|'+
u.UMDescripcion+'|'+CONVERT(VarChar(50), cast(u.ValorUM as money ), 1)+'|'+
convert(varchar,t.PrecioCosto)
from UnidadMedida u
inner join TemporalCompra t
on t.IdProducto=u.IdProducto
where t.UsuarioID=@UsuarioID
order by u.ValorUM asc
for xml path('')),1,1,'')),'true')
end
GO
/****** Object:  StoredProcedure [dbo].[uspEliminaApertura]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspEliminaApertura]
@IdApertura varchar(38)
as
begin
Begin Transaction
delete from DetalleApertura
where IdApertura=@IdApertura
delete from AperturaInsumos
where IdApertura=@IdApertura
Commit Transaction;
select 'true'
end
GO
/****** Object:  StoredProcedure [dbo].[uspEliminaGasto]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspEliminaGasto]
@Data varchar(max)
as
begin
declare @GastoId int
Set @GastoId=convert(int,@Data)
begin
	delete from GastosFijos 
	where GastoId=@GastoId
	select isnull((select STUFF((select '¬'+ CONVERT(varchar,g.GastoId)+'|'+convert(varchar,g.GastoFecha,103)+'|'+
	g.GsstoDesc+'|'+CONVERT(VarChar(50), cast(g.GstoMonto as money ), 1)+'|'+
	(IsNull(convert(varchar,g.GastoReg,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,g.GastoReg,114),1,8),''))+'|'+
	g.GastoUsuario
	from GastosFijos g 
	where month(g.GastoFecha)=month(GETDATE())and year(g.GastoFecha)=year(GETDATE())
	order by g.GastoFecha asc,g.GastoId asc
	FOR XML PATH('')), 1, 1, '')),'~')
end
end
GO
/****** Object:  StoredProcedure [dbo].[uspEliminarMesas]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspEliminarMesas]
@id_mesa int
As
BEGIN
Delete From tbl_mesa 
Where id_mesa=@id_mesa
Select isnull((Select STUFF((Select '¬' + convert(varchar,id_mesa) + '|' + nro_mesa + '|' + 
convert(varchar,capacidad) + '|' + ubicacion + '|' + estado
From tbl_mesa
order by nro_mesa desc
FOR XML PATH('')), 1, 1, '')),'~')
END
GO
/****** Object:  StoredProcedure [dbo].[uspGasto]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspGasto]
as
begin
select
'Id|Fecha|Descripcion|Monto|FechaRe|Usuario¬100|120|415|125|100|100¬String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+ CONVERT(varchar,g.GastoId)+'|'+convert(varchar,g.GastoFecha,103)+'|'+
g.GsstoDesc+'|'+CONVERT(VarChar(50), cast(g.GstoMonto as money ), 1)+'|'+
(IsNull(convert(varchar,g.GastoReg,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,g.GastoReg,114),1,8),''))+'|'+
g.GastoUsuario
from GastosFijos g 
where month(g.GastoFecha)=month(GETDATE())and year(g.GastoFecha)=year(GETDATE())
order by g.GastoFecha asc,g.GastoId asc
FOR XML PATH('')), 1, 1, '')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspGastoFecha]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspGastoFecha]
@fechainicio date,@fechafin date
as
begin
select
'Id|Fecha|Descripcion|Monto|FechaRe|Usuario¬100|120|415|125|100|100¬String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+ CONVERT(varchar,g.GastoId)+'|'+convert(varchar,g.GastoFecha,103)+'|'+
g.GsstoDesc+'|'+CONVERT(VarChar(50), cast(g.GstoMonto as money ), 1)+'|'+
(IsNull(convert(varchar,g.GastoReg,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,g.GastoReg,114),1,8),''))+'|'+
g.GastoUsuario
from GastosFijos g 
where (Convert(char(10),g.GastoFecha,103) BETWEEN @fechainicio AND @fechafin)
order by g.GastoFecha asc,g.GastoId asc
FOR XML PATH('')), 1, 1, '')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspHistoria]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspHistoria]
@ClienteId numeric(20),
@IdProducto numeric(20)
as
begin
select
'FechaVenta|PrecioUni|Cantidad|UM|Vendedor¬140|100|100|80|150¬String|String|String|String|String¬'+
isnull((select stuff((select '¬'+(IsNull(convert(varchar,n.NotaFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,n.NotaFecha,114),1,8),''))+'|'+
CONVERT(VarChar(50),cast(d.DetallePrecio as money ), 1)+'|'+
CONVERT(VarChar(50),cast(d.DetalleCantidad as money ), 1)+'|'+d.DetalleUm+'|'+
n.NotaUsuario
from DetallePedido d 
inner join NotaPedido n 
on n.NotaId=d.NotaId
where n.ClienteId=@ClienteId and (d.IdProducto=@IdProducto and n.NotaEstado<>'PENDIENTE') 
order by n.NotaFecha desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspInsertaCabeceraDetalle]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspInsertaCabeceraDetalle]
@ListaOrden varchar(Max)
as
begin
Declare @psc1 int,@psc2 int,@psc3 int
Declare @orden varchar(max)
Declare @detalle varchar(max)
Declare @detalleMesas varchar(max)

Set @psc1 = CharIndex('[',@ListaOrden,0)
Set @psc2 = CharIndex('[',@ListaOrden,@psc1+1)
Set @psc3 =Len(@ListaOrden)+1

Set @orden = SUBSTRING(@ListaOrden,1,@psc1-1)
Set @detalle = SUBSTRING(@ListaOrden,@psc1+1,@psc2-@psc1-1)
Set @detalleMesas=SUBSTRING(@ListaOrden,@psc2+1,@psc3-@psc2-1)

Declare @pos1 int,@pos2 int,@pos3 int,@pos4 int,@pos5 int,@pos6 int,
        @pos7 int,@pos8 int,@pos9 int,@pos10 int
Declare 
		@IdOrden numeric(38),@ClienteId numeric(20),@OrdenSerie char(4),
		@OrdenNumero varchar(40),@NroMesas varchar(80),
        @Observaciones varchar(300),@Usuario varchar(80),@Total decimal(18,2),
        @Estado nvarchar(20),@estadoMesa varchar(20)
        
Set @pos1 = CharIndex('|',@orden,0)--cabezera
Set @pos2 = CharIndex('|',@orden,@pos1+1)
Set @pos3 = CharIndex('|',@orden,@pos2+1)
Set @pos4 = CharIndex('|',@orden,@pos3+1)
Set @pos5 = CharIndex('|',@orden,@pos4+1)
Set @pos6= CharIndex('|',@orden,@pos5+1)
Set @pos7 = CharIndex('|',@orden,@pos6+1)
Set @pos8 = CharIndex('|',@orden,@pos7+1)
Set @pos9= CharIndex('|',@orden,@pos8+1)
Set @pos10 =Len(@orden)+1

Set @IdOrden        =convert(numeric(38),SUBSTRING(@orden,1,@pos1-1))
Set @ClienteId     	=convert(numeric(20),SUBSTRING(@orden,@pos1+1,@pos2-@pos1-1))
Set	@OrdenSerie		=SUBSTRING(@orden,@pos2+1,@pos3-@pos2-1)
Set	@OrdenNumero	=SUBSTRING(@orden,@pos3+1,@pos4-@pos3-1)
Set	@NroMesas		=SUBSTRING(@orden,@pos4+1,@pos5-@pos4-1)
Set	@Observaciones	=SUBSTRING(@orden,@pos5+1,@pos6-@pos5-1)
Set	@Usuario		=SUBSTRING(@orden,@pos6+1,@pos7-@pos6-1)
Set	@Total		    =convert(decimal(18,2),SUBSTRING(@orden,@pos7+1,@pos8-@pos7-1))
Set	@Estado			=SUBSTRING(@orden,@pos8+1,@pos9-@pos8-1)
Set	@estadoMesa		=SUBSTRING(@orden,@pos9+1,@pos10-@pos9-1)

Begin Transaction
If (@IdOrden =0)
begin
	insert into Tbl_Orden_Pedido values(@ClienteId,GETDATE(),null,@OrdenSerie,
	@OrdenNumero,@NroMesas,@Observaciones,@Usuario,@Total,@Estado)
	Set @IdOrden = @@identity
end
else
begin
    if(@estadoMesa='POR SALIR')
    begin
    set @Estado='ENVIADO'
    end
	update Tbl_Orden_Pedido 
	set ClienteId=@ClienteId,HoraFin=GETDATE(),OrdenSerie=@OrdenSerie,
	OrdenNumero=@OrdenNumero,NroMesas=@NroMesas,Observaciones=@Observaciones,
	Total=@Total,Estado=@Estado
    where IdOrden=@IdOrden
end
   Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla               
        
Declare @Columna varchar(max),
		@id_detalle_orden numeric(20),		
		@id_producto numeric(20),
		@cantidad decimal(18,2),
		@precio_unitario decimal(18,2),
		@importe decimal(18,2),
		@estado_detalle nvarchar(20)
	
Declare @p1 int,@p2 int,@p3 int,
		@p4 int,@p5 int, @p6 int
		        
Fetch Next From Tabla INTO @Columna
	While @@FETCH_STATUS = 0
	Begin
Set @p1 = CharIndex('|',@Columna,0)
Set @p2 = CharIndex('|',@Columna,@p1+1)
Set @p3 = CharIndex('|',@Columna,@p2+1)
Set @p4 = CharIndex('|',@Columna,@p3+1)
Set @p5 = CharIndex('|',@Columna,@p4+1)
Set @p6 = Len(@Columna)+1

Set @id_detalle_orden	=Convert(numeric(38),SUBSTRING(@Columna,1,@p1-1))
Set @id_producto		=Convert(numeric(20),SUBSTRING(@Columna,@p1+1,@p2-(@p1+1)))
Set @cantidad			=Convert(decimal(18,2),SUBSTRING(@Columna,@p2+1,@p3-(@p2+1)))
Set @precio_unitario	=Convert(decimal(18,2),SUBSTRING(@Columna,@p3+1,@p4-(@p3+1)))
Set @importe			=Convert(decimal(18,2),SUBSTRING(@Columna,@p4+1,@p5-(@p4+1)))
Set @estado_detalle		=SUBSTRING(@Columna,@p5+1,@p6-(@p5+1))
	
if (@id_detalle_orden=0)
	insert into Tbl_Detalle_Orden
	values(@IdOrden,@id_producto, @cantidad,@precio_unitario, @importe,@estado_detalle)
else
	update Tbl_Detalle_Orden
	set IdOrden=@IdOrden,IdProducto=@id_producto,Cantidad=@cantidad,
	PrecioUni=@precio_unitario,Importe=@importe ,Estado=@estado_detalle
	where DetalleId=@id_detalle_orden
	
Fetch Next From Tabla INTO @Columna
end
	Close Tabla;--CIERRO CURSOR
	Deallocate Tabla;--LIBERA RECURSOS
------------------------------------------------------
if(len(@detalleMesas)>0)
begin
Declare TablaB Cursor For Select * From fnSplitString(@detalleMesas,';')	
Open TablaB

Declare @ColumnaB varchar(max),@id_mesa_det int
Declare @n1 int

Fetch Next From TablaB INTO @ColumnaB
	While @@FETCH_STATUS = 0
	Begin
Set @n1=Len(@ColumnaB)+1
set @id_mesa_det=Convert(numeric(38),SUBSTRING(@ColumnaB,1,@n1-1))

IF  NOT EXISTS(select c.id_mesa from Combinacion_Mesas c 
where c.IdOrden=@IdOrden and c.id_mesa=@id_mesa_det)
begin
insert into Combinacion_Mesas values(@IdOrden,@id_mesa_det)
update tbl_mesa 
set estado=@estadoMesa 
where id_mesa=@id_mesa_det
end
else
begin
update tbl_mesa 
set estado=@estadoMesa 
where id_mesa=@id_mesa_det
end
Fetch Next From TablaB INTO @ColumnaB
end
	Close TablaB;
	Deallocate TablaB;
    Commit Transaction;
    select 'true'--GUARDO CORRECTAMENTE
end
else
begin
    Commit Transaction;
    select 'true'--GUARDO CORRECTAMENTE
end
end
GO
/****** Object:  StoredProcedure [dbo].[uspinsertaFactura]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspinsertaFactura]  
@ListaOrden varchar(Max)  
as  
begin  
Declare @pos int  
Declare @orden varchar(max)  
Declare @detalle varchar(max)  
Set @pos = CharIndex('[',@ListaOrden,0)  
Set @orden = SUBSTRING(@ListaOrden,1,@pos-1)  
Set @detalle = SUBSTRING(@ListaOrden,@pos+1,len(@ListaOrden)-@pos)  
Declare @pos1 int,@pos2 int,@pos3 int,@pos4 int,  
        @pos5 int,@pos6 int,@pos7 int,@pos8 int,  
        @pos9 int,@pos10 int,@pos11 int,@pos12 int,  
        @pos13 int,@pos14 int,@pos15 int,@pos16 int,  
        @pos17 int,@pos18 int,@pos19 int,@pos20 int,  
        @pos21 int,@pos22 int,@pos23 int,@pos24 int,  
        @pos25 int,@pos26 int,@pos27 int  
 Declare @CompaniaId int,@NotaId numeric(38),@DocuDocumento varchar(60),  
         @DocuNumero varchar(60),@ClienteId numeric(20),@DocuEmision date,  
         @DocuSubTotal decimal(18,2),@DocuIgv decimal(18,2),@DocuTotal decimal(18,2),  
         @DocuUsuario varchar(60),@DocuSerie char(4),@TipoCodigo char(20),  
         @DocuAdicional decimal(18,2),@DocuAsociado varchar(80),  
         @DocuConcepto varchar(80),@DocuHASH varchar(250),@EstadoSunat varchar(80),  
         @Letras varchar(60),@DocuId numeric(38),@TraeEstado varchar(80),  
         @CajaId numeric(38),@UsuarioId int,@NotaFormaPago varchar(60),  
         @Movimiento varchar(40),@Efectivo decimal(18,2),@Vuelto decimal(18,2),  
         @CodigoSunat VARCHAR(80),@MensajeSunat varchar(max),  
         @ICBPER decimal(18,2),@DocuGravada decimal(18,2),@DocuDescuento decimal(18,2)  
Set @pos1 = CharIndex('|',@orden,0)  
Set @pos2 = CharIndex('|',@orden,@pos1+1)  
Set @pos3 = CharIndex('|',@orden,@pos2+1)  
Set @pos4 = CharIndex('|',@orden,@pos3+1)  
Set @pos5 = CharIndex('|',@orden,@pos4+1)  
Set @pos6= CharIndex('|',@orden,@pos5+1)  
Set @pos7 = CharIndex('|',@orden,@pos6+1)  
Set @pos8 = CharIndex('|',@orden,@pos7+1)  
Set @pos9 = CharIndex('|',@orden,@pos8+1)  
Set @pos10= CharIndex('|',@orden,@pos9+1)  
Set @pos11= CharIndex('|',@orden,@pos10+1)  
Set @pos12= CharIndex('|',@orden,@pos11+1)  
Set @pos13= CharIndex('|',@orden,@pos12+1)  
Set @pos14= CharIndex('|',@orden,@pos13+1)  
Set @pos15= CharIndex('|',@orden,@pos14+1)  
Set @pos16= CharIndex('|',@orden,@pos15+1)  
Set @pos17= CharIndex('|',@orden,@pos16+1)  
Set @pos18= CharIndex('|',@orden,@pos17+1)  
Set @pos19= CharIndex('|',@orden,@pos18+1)  
Set @pos20= CharIndex('|',@orden,@pos19+1)  
Set @pos21= CharIndex('|',@orden,@pos20+1)  
Set @pos22= CharIndex('|',@orden,@pos21+1)  
Set @pos23= CharIndex('|',@orden,@pos22+1)  
Set @pos24= CharIndex('|',@orden,@pos23+1)  
Set @pos25= CharIndex('|',@orden,@pos24+1)  
Set @pos26= CharIndex('|',@orden,@pos25+1)  
Set @pos27= Len(@orden)+1  
Set @CompaniaId=convert(int,SUBSTRING(@orden,1,@pos1-1))  
Set @NotaId=convert(numeric(38),SUBSTRING(@orden,@pos1+1,@pos2-@pos1-1))  
Set @DocuDocumento=SUBSTRING(@orden,@pos2+1,@pos3-@pos2-1)  
Set @DocuNumero=SUBSTRING(@orden,@pos3+1,@pos4-@pos3-1)  
Set @ClienteId=convert(numeric(20),SUBSTRING(@orden,@pos4+1,@pos5-@pos4-1))  
Set @DocuEmision=convert(date,SUBSTRING(@orden,@pos5+1,@pos6-@pos5-1))  
Set @DocuSubTotal=convert(decimal(18,2),SUBSTRING(@orden,@pos6+1,@pos7-@pos6-1))  
Set @DocuIgv=convert(decimal(18,2),SUBSTRING(@orden,@pos7+1,@pos8-@pos7-1))  
Set @DocuTotal=convert(decimal(18,2),SUBSTRING(@orden,@pos8+1,@pos9-@pos8-1))  
Set @DocuUsuario=SUBSTRING(@orden,@pos9+1,@pos10-@pos9-1)  
Set @DocuSerie=SUBSTRING(@orden,@pos10+1,@pos11-@pos10-1)  
Set @TipoCodigo=SUBSTRING(@orden,@pos11+1,@pos12-@pos11-1)  
set @DocuAdicional=convert(decimal(18,2),SUBSTRING(@orden,@pos12+1,@pos13-@pos12-1))  
set @DocuAsociado=SUBSTRING(@orden,@pos13+1,@pos14-@pos13-1)  
set @DocuConcepto=SUBSTRING(@orden,@pos14+1,@pos15-@pos14-1)  
set @DocuHASH=SUBSTRING(@orden,@pos15+1,@pos16-@pos15-1)  
set @EstadoSunat=SUBSTRING(@orden,@pos16+1,@pos17-@pos16-1)  
set @Letras=SUBSTRING(@orden,@pos17+1,@pos18-@pos17-1)  
set @UsuarioId=convert(int,SUBSTRING(@orden,@pos18+1,@pos19-@pos18-1))  
set @NotaFormaPago=SUBSTRING(@orden,@pos19+1,@pos20-@pos19-1)  
set @Efectivo=convert(decimal(18,2),SUBSTRING(@orden,@pos20+1,@pos21-@pos20-1))  
set @Vuelto=convert(decimal(18,2),SUBSTRING(@orden,@pos21+1,@pos22-@pos21-1))  
set @CodigoSunat=SUBSTRING(@orden,@pos22+1,@pos23-@pos22-1)  
set @MensajeSunat=SUBSTRING(@orden,@pos23+1,@pos24-@pos23-1)  
set @ICBPER=convert(decimal(18,2),SUBSTRING(@orden,@pos24+1,@pos25-@pos24-1))  
set @DocuGravada=convert(decimal(18,2),SUBSTRING(@orden,@pos25+1,@pos26-@pos25-1))  
set @DocuDescuento=convert(decimal(18,2),SUBSTRING(@orden,@pos26+1,@pos27-@pos26-1))  
set @CajaId=isnull((select top 1 CajaId from Caja where CajaEstado='ACTIVO'   
and UsuarioId=@UsuarioId order by 1 desc),'0')  
if(@CajaId=0)  
begin  
select 'false'  
end  
else  
begin  
Begin Transaction  
insert into DocumentoVenta values(@CompaniaId,@NotaId,@DocuDocumento,@DocuNumero,  
@ClienteId,GETDATE(),@DocuEmision,'ALCONTADO',@DocuEmision,@Letras,@DocuSubTotal,  
@DocuIgv,@DocuTotal,0,@DocuUsuario,'EMITIDO',@DocuSerie,@TipoCodigo,  
@DocuAdicional,@DocuAsociado,@DocuConcepto,'',@DocuHASH,@EstadoSunat,  
@CodigoSunat,@MensajeSunat,@ICBPER,@DocuGravada,@DocuDescuento)  
Set @DocuId= @@identity  
if(@NotaFormaPago='EFECTIVO')set @Movimiento='INGRESO'  
else set @Movimiento='TARJETA'  
insert into CajaDetalle values(@CajaId,GETDATE(),@NotaId,@Movimiento,'',  
'Transacción con '+@NotaFormaPago,'SOLES',0,@DocuTotal,@Efectivo,@Vuelto)  
update NotaPedido   
set CompaniaId=@CompaniaId,NotaSerie=@DocuSerie,NotaSaldo=0,  
NotaAcuenta=@DocuTotal,NotaNumero=@DocuNumero,NotaEstado='CANCELADO',CajaId=@CajaId  
where NotaId=@NotaId  
   Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')   
Open Tabla  
Declare @Columna varchar(max),  
  @IdProducto numeric(20),  
  @Cantidad decimal(18,2),  
  @Precio decimal(18,2),  
  @Importe decimal(18,2),  
  @DetalleNotaId numeric(38),  
  @UM varchar(80),  
  @ValorUM decimal(18,4),  
  @IniciaStock decimal(18,2),@StockFinal decimal(18,2)  
Declare @p1 int,@p2 int,@p3 int,@p4 int,  
        @p5 int,@p6 int,@p7 int  
Fetch Next From Tabla INTO @Columna  
 While @@FETCH_STATUS = 0  
 Begin  
Set @p1 = CharIndex('|',@Columna,0)  
Set @p2 = CharIndex('|',@Columna,@p1+1)  
Set @p3 = CharIndex('|',@Columna,@p2+1)  
Set @p4 = CharIndex('|',@Columna,@p3+1)  
Set @p5 = CharIndex('|',@Columna,@p4+1)  
Set @p6= CharIndex('|',@Columna,@p5+1)  
Set @p7 = Len(@Columna)+1  
Set @DetalleNotaId=Convert(numeric(38),SUBSTRING(@Columna,1,@p1-1))  
Set @IdProducto=Convert(numeric(20),SUBSTRING(@Columna,@p1+1,@p2-(@p1+1)))  
Set @Cantidad=Convert(decimal(18,2),SUBSTRING(@Columna,@p2+1,@p3-(@p2+1)))  
Set @UM=SUBSTRING(@Columna,@p3+1,@p4-(@p3+1))  
Set @Precio=Convert(decimal(18,2),SUBSTRING(@Columna,@p4+1,@p5-(@p4+1)))  
Set @Importe=Convert(decimal(18,2),SUBSTRING(@Columna,@p5+1,@p6-(@p5+1)))  
Set @ValorUM=Convert(decimal(18,4),SUBSTRING(@Columna,@p6+1,@p7-(@p6+1)))  

 insert into DetalleDocumento values(@DocuId,@IdProducto,@Cantidad,
 @Precio,@Importe,@DetalleNotaId,@UM,@ValorUM)  

 set @Cantidad=@Cantidad*@ValorUM
 
 set @IniciaStock=(select top 1 ProductoCantidad from Producto where IdProducto=@IdProducto)  
 set @StockFinal=@IniciaStock-@Cantidad  
 
 insert into Kardex values(@IdProducto,GETDATE(),'Salida por Venta',@DocuSerie+'-'+@DocuNumero,@IniciaStock,  
 0,@Cantidad,@Precio,@StockFinal,'SALIDA',@DocuUsuario)  
 
 update producto   
 set  ProductoCantidad =ProductoCantidad - @Cantidad  
 where IDProducto=@IdProducto  

Fetch Next From Tabla INTO @Columna  
end  
 Close Tabla;  
 Deallocate Tabla;  
    Declare @EstadoDetalle varchar(80)  
 if(@EstadoSunat='PENDIENTE')set @EstadoDetalle='PENDIENTEB'  
 else set @EstadoDetalle='EMITIDO'  
 update DetallePedido  
 set DetalleEstado=@EstadoDetalle  
 where NotaId=@NotaId  
 Commit Transaction;  
select 'true'  
end  
end
GO
/****** Object:  StoredProcedure [dbo].[uspinsertaGasto]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspinsertaGasto]
@Data varchar(max)
as
begin
Declare @pos1 int
Declare @pos2 int
Declare @pos3 int
Declare @pos4 int
Declare @pos5 int
declare
@GastoId int,
@GastoFecha date,
@GsstoDesc varchar(max),
@GstoMonto decimal(18,2),
@GastoUsuario varchar(80)
Set @Data = LTRIM(RTrim(@Data))
Set @pos1 = CharIndex('|',@Data,0)
Set @GastoId=convert(int,SUBSTRING(@Data,1,@pos1-1))
Set @pos2 = CharIndex('|',@Data,@pos1+1)
Set @GastoFecha=convert(date,SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))
Set @pos3 = CharIndex('|',@Data,@pos2+1)
Set @GsstoDesc=SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1)
Set @pos4 = CharIndex('|',@Data,@pos3+1)
Set @GstoMonto=convert(decimal(18,2),SUBSTRING(@Data,@pos3+1,@pos4-@pos3-1))
Set @pos5= Len(@Data)+1
Set @GastoUsuario=SUBSTRING(@Data,@pos4+1,@pos5-@pos4-1)
if @GastoId=0
begin
IF EXISTS(select * from GastosFijos g where g.GsstoDesc=@GsstoDesc and
(Month(g.GastoFecha)=MONTH(@GastoFecha) and year(g.GastoFecha)=YEAR(@GastoFecha)))
select 'existe'
else
begin
insert into GastosFijos values(@GastoFecha,@GsstoDesc,@GstoMonto,GETDATE(),@GastoUsuario)
	select isnull((select STUFF((select '¬'+ CONVERT(varchar,g.GastoId)+'|'+convert(varchar,g.GastoFecha,103)+'|'+
	g.GsstoDesc+'|'+CONVERT(VarChar(50), cast(g.GstoMonto as money ), 1)+'|'+
	(IsNull(convert(varchar,g.GastoReg,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,g.GastoReg,114),1,8),''))+'|'+
	g.GastoUsuario
	from GastosFijos g 
	where month(g.GastoFecha)=month(GETDATE())and year(g.GastoFecha)=year(GETDATE())
	order by g.GastoFecha asc,g.GastoId asc
	FOR XML PATH('')), 1, 1, '')),'~')	
end
end
end
GO
/****** Object:  StoredProcedure [dbo].[uspinsertarApertura]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspinsertarApertura]
@ListaOrden varchar(Max)
as
begin
Declare @pos int
Declare @orden varchar(max)
Declare @detalle varchar(max)
Set @pos = CharIndex('[',@ListaOrden,0)
Set @orden = SUBSTRING(@ListaOrden,1,@pos-1)
Set @detalle = SUBSTRING(@ListaOrden,@pos+1,len(@ListaOrden)-@pos)
Declare @pos1 int,@pos2 int,
        @pos3 int,@pos4 int
Declare @IdApertura numeric(38),@FechaApertura date,
        @FechaCierre datetime,@Usuario varchar(80),
        @Estado nvarchar(20)
Set @pos1 = CharIndex('|',@orden,0)
Set @pos2 = CharIndex('|',@orden,@pos1+1)
Set @pos3 = CharIndex('|',@orden,@pos2+1)
Set @pos4 =  Len(@orden)+1
Set @IdApertura=convert(numeric(38),SUBSTRING(@orden,1,@pos1-1))
Set @FechaApertura=convert(date,SUBSTRING(@orden,@pos1+1,@pos2-@pos1-1))
Set @Usuario=SUBSTRING(@orden,@pos2+1,@pos3-@pos2-1)
Set @Estado=SUBSTRING(@orden,@pos3+1,@pos4-@pos3-1)
Declare @Aviso int
if(@IdApertura=0)
begin
IF EXISTS(select top 1 Convert(char(10),a.FechaApertura,103) from AperturaInsumos a
where a.FechaApertura=@FechaApertura)
begin
set @Aviso=1
end
else
begin
set @Aviso=0
end
end
else
begin
set @Aviso=0
end
if(@Aviso=0)
begin
if(@Estado='ACTIVO')set @FechaCierre=null
else set @FechaCierre=GETDATE()
Begin Transaction
if(@IdApertura=0)
begin
insert into AperturaInsumos values(@FechaApertura,@FechaCierre,@Usuario,@Estado)
set @IdApertura=@@IDENTITY
end
else
begin
update AperturaInsumos
set FechaApertura=@FechaApertura,FechaCierre=@FechaCierre,Usuario=@Usuario,
Estado=@Estado
where IdApertura=@IdApertura
end
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
Declare @Columna varchar(max),
		@DetalleId numeric(38),@Descripcion varchar(max),
		@Ingreso decimal(18,3),@DeIngreso varchar(10),
		@Cierre decimal(18,3),@DeCierre varchar(10),
		@Total varchar(80)
Declare @p1 int,@p2 int,@p3 int,@p4 int,
        @p5 int,@p6 int,@p7 int
Fetch Next From Tabla INTO @Columna
	While @@FETCH_STATUS = 0
	Begin
Set @p1 = CharIndex('|',@Columna,0)
Set @p2 = CharIndex('|',@Columna,@p1+1)
Set @p3 = CharIndex('|',@Columna,@p2+1)
Set @p4 = CharIndex('|',@Columna,@p3+1)
Set @p5 = CharIndex('|',@Columna,@p4+1)
Set @p6= CharIndex('|',@Columna,@p5+1)
Set @p7 = Len(@Columna)+1
Set @DetalleId=Convert(numeric(38),SUBSTRING(@Columna,1,@p1-1))
Set @Descripcion=SUBSTRING(@Columna,@p1+1,@p2-(@p1+1))
Set @Ingreso=Convert(decimal(18,3),SUBSTRING(@Columna,@p2+1,@p3-(@p2+1)))
Set @DeIngreso=SUBSTRING(@Columna,@p3+1,@p4-(@p3+1))
Set @Cierre=Convert(decimal(18,3),SUBSTRING(@Columna,@p4+1,@p5-(@p4+1)))
Set @DeCierre=SUBSTRING(@Columna,@p5+1,@p6-(@p5+1))
Set @Total=SUBSTRING(@Columna,@p6+1,@p7-(@p6+1))
if(@DetalleId=0)
begin
insert into DetalleApertura values(@IdApertura,@Descripcion,@Ingreso,
@DeIngreso,@Cierre,@DeCierre,@Total)
end
else
begin
update DetalleApertura
set Descripcion=@Descripcion,Ingreso=@Ingreso,DeIngreso=@DeIngreso,
Cierre=@Cierre,DeCierre=@DeCierre,Total=@Total
where DetalleId=@DetalleId
end
Fetch Next From Tabla INTO @Columna
end
	Close Tabla;
	Deallocate Tabla;
	Commit Transaction;
	select 'true'
end
else
begin
select 'existe'
end
end
GO
/****** Object:  StoredProcedure [dbo].[uspInsertarCuenta]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspInsertarCuenta]
@Data varchar(max)
as
begin
Declare @pos1 int
Declare @pos2 int
Declare @pos3 int
Declare @pos4 int
Declare @pos5 int
Declare @pos6 int
declare @CuentaId numeric(38),
@ProveedorId numeric(38),
@Entidad varchar(80),
@TipoCuenta varchar(80),
@Moneda varchar(80),
@NroCuenta varchar(80)
Set @Data = LTRIM(RTrim(@Data))
Set @pos1 = CharIndex('|',@Data,0)
Set @CuentaId=convert(numeric(38),SUBSTRING(@Data,1,@pos1-1))
Set @pos2 = CharIndex('|',@Data,@pos1+1)
Set @ProveedorId=convert(numeric(38),SUBSTRING(@Data,@pos1+1,@pos2-@pos1-1))
Set @pos3 = CharIndex('|',@Data,@pos2+1)
Set @Entidad=SUBSTRING(@Data,@pos2+1,@pos3-@pos2-1)
Set @pos4 = CharIndex('|',@Data,@pos3+1)
Set @TipoCuenta=SUBSTRING(@Data,@pos3+1,@pos4-@pos3-1)
Set @pos5 = CharIndex('|',@Data,@pos4+1)
Set @Moneda=SUBSTRING(@Data,@pos4+1,@pos5-@pos4-1)
Set @pos6 = Len(@Data)+1
Set @NroCuenta=SUBSTRING(@Data,@pos5+1,@pos6-@pos5-1)
if(@CuentaId=0)
begin
insert into CuentaProveedor values(@ProveedorId,@Entidad,@TipoCuenta,@Moneda,@NroCuenta)
select isnull((select STUFF ((select '¬'+ CONVERT(varchar,c.CuentaId)+'|'+c.Entidad+'|'+
c.TipoCuenta+'|'+c.Moneda+'|'+c.NroCuenta
from CuentaProveedor c
where c.ProveedorId=@ProveedorId
order by c.CuentaId desc
for xml path('')),1,1,'')),'~')
end
else
begin
update CuentaProveedor
set TipoCuenta=@TipoCuenta,NroCuenta=@NroCuenta
where CuentaId=@CuentaId
select 'true'
end
end
GO
/****** Object:  StoredProcedure [dbo].[uspinsertaRechazo]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspinsertaRechazo]
@ListaOrden varchar(Max)
as
begin
Declare @pos int
Declare @orden varchar(max)
Declare @detalle varchar(max)
Set @pos = CharIndex('[',@ListaOrden,0)
Set @orden = SUBSTRING(@ListaOrden,1,@pos-1)
Set @detalle = SUBSTRING(@ListaOrden,@pos+1,len(@ListaOrden)-@pos)
Declare @pos1 int,@pos2 int,@pos3 int,@pos4 int,
        @pos5 int,@pos6 int,@pos7 int,@pos8 int,
        @pos9 int,@pos10 int,@pos11 int,@pos12 int,
        @pos13 int,@pos14 int,@pos15 int
 Declare @CompaniaId int,@NotaId numeric(38),@DocuDocumento varchar(60),
         @DocuNumero varchar(60),@ClienteId numeric(20),@DocuEmision date,
         @DocuUsuario varchar(60),@DocuSerie char(4),@TipoCodigo char(20),
         @DocuConcepto varchar(80),@DocuHASH varchar(250),@EstadoSunat varchar(80),
         @Letras varchar(60),@DocuId numeric(38),@TraeEstado varchar(80),
         @NotaEstado varchar(80),@CodigoSunat VARCHAR(80),@MensajeSunat varchar(max)
Set @pos1 = CharIndex('|',@orden,0)
Set @pos2 = CharIndex('|',@orden,@pos1+1)
Set @pos3 = CharIndex('|',@orden,@pos2+1)
Set @pos4 = CharIndex('|',@orden,@pos3+1)
Set @pos5 = CharIndex('|',@orden,@pos4+1)
Set @pos6= CharIndex('|',@orden,@pos5+1)
Set @pos7 = CharIndex('|',@orden,@pos6+1)
Set @pos8 = CharIndex('|',@orden,@pos7+1)
Set @pos9 = CharIndex('|',@orden,@pos8+1)
Set @pos10= CharIndex('|',@orden,@pos9+1)
Set @pos11= CharIndex('|',@orden,@pos10+1)
Set @pos12= CharIndex('|',@orden,@pos11+1)
Set @pos13= CharIndex('|',@orden,@pos12+1)
Set @pos14= CharIndex('|',@orden,@pos13+1)
Set @pos15=Len(@orden)+1
Set @CompaniaId=convert(int,SUBSTRING(@orden,1,@pos1-1))
Set @NotaId=convert(numeric(38),SUBSTRING(@orden,@pos1+1,@pos2-@pos1-1))
Set @DocuDocumento=SUBSTRING(@orden,@pos2+1,@pos3-@pos2-1)
Set @DocuNumero=SUBSTRING(@orden,@pos3+1,@pos4-@pos3-1)
Set @ClienteId=convert(numeric(20),SUBSTRING(@orden,@pos4+1,@pos5-@pos4-1))
Set @DocuEmision=convert(date,SUBSTRING(@orden,@pos5+1,@pos6-@pos5-1))
Set @DocuUsuario=SUBSTRING(@orden,@pos6+1,@pos7-@pos6-1)
Set @DocuSerie=SUBSTRING(@orden,@pos7+1,@pos8-@pos7-1)
Set @TipoCodigo=SUBSTRING(@orden,@pos8+1,@pos9-@pos8-1)
set @DocuConcepto=SUBSTRING(@orden,@pos9+1,@pos10-@pos9-1)
set @DocuHASH=SUBSTRING(@orden,@pos10+1,@pos11-@pos10-1)
set @EstadoSunat=SUBSTRING(@orden,@pos11+1,@pos12-@pos11-1)
set @Letras=SUBSTRING(@orden,@pos12+1,@pos13-@pos12-1)
set @CodigoSunat=SUBSTRING(@orden,@pos13+1,@pos14-@pos13-1)
set @MensajeSunat=SUBSTRING(@orden,@pos14+1,@pos15-@pos14-1)
set @TraeEstado=(select top 1 n.NotaEstado from NotaPedido n where n.NotaId=@NotaId)
if(@TraeEstado='PENDIENTE')set @NotaEstado='EMITIDO'
else set @NotaEstado=@TraeEstado
Begin Transaction
insert into DocumentoVenta values(@CompaniaId,@NotaId,@DocuDocumento,@DocuNumero,
@ClienteId,GETDATE(),@DocuEmision,'ALCONTADO',@DocuEmision,'CERO CON 00/100 SOLES',0,0,0,0,
@DocuUsuario,'RECHAZADO',@DocuSerie,@TipoCodigo,0,'',
@DocuConcepto,'',@DocuHASH,'RECHAZADO',@CodigoSunat,@MensajeSunat,0,0,0)
Set @DocuId= @@identity
update NotaPedido 
set CompaniaId=@CompaniaId,NotaSerie=@DocuSerie,
NotaNumero=@DocuNumero,NotaEstado=@NotaEstado
where NotaId=@NotaId
   Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
Declare @Columna varchar(max),
		@IdProducto numeric(20),
		@Cantidad decimal(18,2),
		@Precio decimal(18,2),
		@Importe decimal(18,2),
		@DetalleNotaId numeric(38),
		@UM varchar(80),
		@ValorUM decimal(18,4)
Declare @p1 int,@p2 int,@p3 int,@p4 int,
        @p5 int,@p6 int,@p7 int
Fetch Next From Tabla INTO @Columna
	While @@FETCH_STATUS = 0
	Begin
Set @p1 = CharIndex('|',@Columna,0)
Set @p2 = CharIndex('|',@Columna,@p1+1)
Set @p3 = CharIndex('|',@Columna,@p2+1)
Set @p4 = CharIndex('|',@Columna,@p3+1)
Set @p5 = CharIndex('|',@Columna,@p4+1)
Set @p6= CharIndex('|',@Columna,@p5+1)
Set @p7 = Len(@Columna)+1
Set @DetalleNotaId=Convert(numeric(38),SUBSTRING(@Columna,1,@p1-1))
Set @IdProducto=Convert(numeric(20),SUBSTRING(@Columna,@p1+1,@p2-(@p1+1)))
Set @Cantidad=Convert(decimal(18,2),SUBSTRING(@Columna,@p2+1,@p3-(@p2+1)))
Set @UM=SUBSTRING(@Columna,@p3+1,@p4-(@p3+1))
Set @Precio=Convert(decimal(18,2),SUBSTRING(@Columna,@p4+1,@p5-(@p4+1)))
Set @Importe=Convert(decimal(18,2),SUBSTRING(@Columna,@p5+1,@p6-(@p5+1)))
Set @ValorUM=Convert(decimal(18,4),SUBSTRING(@Columna,@p6+1,@p7-(@p6+1)))
insert into DetalleDocumento 
values(@DocuId,@IdProducto,@Cantidad,@Precio,@Importe,@DetalleNotaId,@UM,@ValorUM)
Fetch Next From Tabla INTO @Columna
end
	Close Tabla;
	Deallocate Tabla;
	update DetallePedido
	set DetalleEstado='PENDIENTE'
	where NotaId=@NotaId
	Commit Transaction;
select 'true'
end
GO
/****** Object:  StoredProcedure [dbo].[uspInsertarHuella]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspInsertarHuella]
@PersonalId numeric(20),
@PARAM_HUELLA image
as
begin
UPDATE PERSONAL 
SET HUELLA=@PARAM_HUELLA 
WHERE PersonalId=@PersonalId
end
GO
/****** Object:  StoredProcedure [dbo].[uspInsertarMesas]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspInsertarMesas]
@Data varchar(max)
AS
BEGIN
	Declare @p1 int,@p2 int,@p3 int, @p4 int, @p5 int	      
	Declare @id_mesa int, @nro_mesa nvarchar(50), @capacidad int,
	@ubicacion nvarchar(20), @estado nvarchar(15)	
	Set @Data = LTRIM(RTrim(@Data))
	Set @p1 = CharIndex('|',@Data,0)
	Set @p2 = CharIndex('|',@Data,@p1+1)	
	Set @p3 = CharIndex('|',@Data,@p2+1)	
	Set @p4 = CharIndex('|',@Data,@p3+1)		
	Set @p5 = Len(@Data)+1	
	Set @id_mesa		=CONVERT(int,SUBSTRING(@Data,1,@p1-1))
	Set @nro_mesa		=SUBSTRING(@Data,@p1+1,@p2-@p1-1)
	Set	@capacidad		=CONVERT(int,SUBSTRING(@Data,@p2+1,@p3-@p2-1))
	Set	@ubicacion		=SUBSTRING(@Data,@p3+1,@p4-@p3-1)
	Set	@estado			=SUBSTRING(@Data,@p4+1,@p5-@p4-1)
	IF(@id_mesa=0)
		BEGIN
		insert into tbl_mesa values(@nro_mesa, @capacidad,@ubicacion,@estado)
		END
	ELSE
		BEGIN
		update tbl_mesa set nro_mesa=@nro_mesa, capacidad=@capacidad ,ubicacion=@ubicacion, estado=@estado where id_mesa=@id_mesa
		END
Select isnull((Select STUFF((Select '¬' + convert(varchar,id_mesa) + '|' + nro_mesa + '|' + 
convert(varchar,capacidad) + '|' + ubicacion + '|' + estado
From tbl_mesa
order by nro_mesa desc
FOR XML PATH('')), 1, 1, '')),'~')
END
GO
/****** Object:  StoredProcedure [dbo].[uspinsertarNC]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspinsertarNC]    
@ListaOrden varchar(Max)    
as    
begin    
Declare @pos int    
Declare @orden varchar(max)    
Declare @detalle varchar(max)    
Set @pos = CharIndex('[',@ListaOrden,0)    
Set @orden = SUBSTRING(@ListaOrden,1,@pos-1)    
Set @detalle = SUBSTRING(@ListaOrden,@pos+1,len(@ListaOrden)-@pos)    
Declare @pos1 int,@pos2 int,@pos3 int,@pos4 int,    
        @pos5 int,@pos6 int,@pos7 int,@pos8 int,    
        @pos9 int,@pos10 int,@pos11 int,@pos12 int,    
        @pos13 int,@pos14 int,@pos15 int,@pos16 int,    
        @pos17 int,@pos18 int,@pos19 int,@pos20 int,    
        @pos21 int,@pos22 int,@pos23 int,@pos24 int    
 Declare @CompaniaId int,@NotaId numeric(38),@DocuDocumento varchar(60),    
         @DocuNumero varchar(60),@ClienteId numeric(20),@DocuEmision date,    
         @DocuSubTotal decimal(18,2),@DocuIgv decimal(18,2),@DocuTotal decimal(18,2),    
         @DocuUsuario varchar(60),@DocuSerie char(4),@TipoCodigo char(20),    
         @DocuAdicional decimal(18,2),@DocuAsociado varchar(80),@DocuConcepto varchar(80),    
         @DocuHASH varchar(250),@EstadoSunat varchar(80),@Letras varchar(60),@NroReferencia varchar(80),    
         @DocuId numeric(38),@KardexDocu varchar(80),@NotaEstado varchar(80),    
         @CodigoSunat VARCHAR(80),@MensajeSunat varchar(max),    
         @ICBPER decimal(18,2),@DocuGravada decimal(18,2),@DocuDescuento decimal(18,2)    
Set @pos1 = CharIndex('|',@orden,0)    
Set @pos2 = CharIndex('|',@orden,@pos1+1)    
Set @pos3 = CharIndex('|',@orden,@pos2+1)    
Set @pos4 = CharIndex('|',@orden,@pos3+1)    
Set @pos5 = CharIndex('|',@orden,@pos4+1)    
Set @pos6= CharIndex('|',@orden,@pos5+1)    
Set @pos7 = CharIndex('|',@orden,@pos6+1)    
Set @pos8 = CharIndex('|',@orden,@pos7+1)    
Set @pos9 = CharIndex('|',@orden,@pos8+1)    
Set @pos10= CharIndex('|',@orden,@pos9+1)    
Set @pos11= CharIndex('|',@orden,@pos10+1)    
Set @pos12= CharIndex('|',@orden,@pos11+1)    
Set @pos13= CharIndex('|',@orden,@pos12+1)    
Set @pos14= CharIndex('|',@orden,@pos13+1)    
Set @pos15= CharIndex('|',@orden,@pos14+1)    
Set @pos16= CharIndex('|',@orden,@pos15+1)    
Set @pos17= CharIndex('|',@orden,@pos16+1)    
Set @pos18= CharIndex('|',@orden,@pos17+1)    
Set @pos19= CharIndex('|',@orden,@pos18+1)    
Set @pos20= CharIndex('|',@orden,@pos19+1)    
Set @pos21= CharIndex('|',@orden,@pos20+1)    
Set @pos22= CharIndex('|',@orden,@pos21+1)    
Set @pos23= CharIndex('|',@orden,@pos22+1)    
Set @pos24= Len(@orden)+1    
Set @CompaniaId=convert(int,SUBSTRING(@orden,1,@pos1-1))    
Set @NotaId=convert(numeric(38),SUBSTRING(@orden,@pos1+1,@pos2-@pos1-1))    
Set @DocuDocumento=SUBSTRING(@orden,@pos2+1,@pos3-@pos2-1)    
Set @DocuNumero=SUBSTRING(@orden,@pos3+1,@pos4-@pos3-1)    
Set @ClienteId=convert(numeric(20),SUBSTRING(@orden,@pos4+1,@pos5-@pos4-1))    
Set @DocuEmision=convert(date,SUBSTRING(@orden,@pos5+1,@pos6-@pos5-1))    
Set @DocuSubTotal=convert(decimal(18,2),SUBSTRING(@orden,@pos6+1,@pos7-@pos6-1))    
Set @DocuIgv=convert(decimal(18,2),SUBSTRING(@orden,@pos7+1,@pos8-@pos7-1))    
Set @DocuTotal=convert(decimal(18,2),SUBSTRING(@orden,@pos8+1,@pos9-@pos8-1))    
Set @DocuUsuario=SUBSTRING(@orden,@pos9+1,@pos10-@pos9-1)    
Set @DocuSerie=SUBSTRING(@orden,@pos10+1,@pos11-@pos10-1)    
Set @TipoCodigo=SUBSTRING(@orden,@pos11+1,@pos12-@pos11-1)    
set @DocuAdicional=convert(decimal(18,2),SUBSTRING(@orden,@pos12+1,@pos13-@pos12-1))    
set @DocuAsociado=SUBSTRING(@orden,@pos13+1,@pos14-@pos13-1)    
set @DocuConcepto=SUBSTRING(@orden,@pos14+1,@pos15-@pos14-1)    
set @DocuHASH=SUBSTRING(@orden,@pos15+1,@pos16-@pos15-1)    
set @EstadoSunat=SUBSTRING(@orden,@pos16+1,@pos17-@pos16-1)    
set @Letras=SUBSTRING(@orden,@pos17+1,@pos18-@pos17-1)    
set @NroReferencia=SUBSTRING(@orden,@pos18+1,@pos19-@pos18-1)    
set @CodigoSunat=SUBSTRING(@orden,@pos19+1,@pos20-@pos19-1)    
set @MensajeSunat=SUBSTRING(@orden,@pos20+1,@pos21-@pos20-1)    
set @ICBPER=convert(decimal(18,2),SUBSTRING(@orden,@pos21+1,@pos22-@pos21-1))    
set @DocuGravada=convert(decimal(18,2),SUBSTRING(@orden,@pos22+1,@pos23-@pos22-1))    
set @DocuDescuento=convert(decimal(18,2),SUBSTRING(@orden,@pos23+1,@pos24-@pos23-1))    
set @NotaEstado=(select NotaEstado from NotaPedido(Nolock) where NotaId=@NotaId)    
Begin Transaction    
insert into DocumentoVenta values(@CompaniaId,@NotaId,@DocuDocumento,@DocuNumero,    
@ClienteId,GETDATE(),@DocuEmision,'ALCONTADO',    
@DocuEmision,@Letras,@DocuSubTotal,@DocuIgv,@DocuTotal,0,    
@DocuUsuario,'EMITIDO',@DocuSerie,@TipoCodigo,@DocuAdicional,@DocuAsociado,    
@DocuConcepto,@NroReferencia,@DocuHASH,@EstadoSunat,@CodigoSunat,@MensajeSunat,    
@ICBPER,@DocuGravada,@DocuDescuento)    
Set @DocuId= @@identity    
set @KardexDocu='NC '+@DocuSerie+'-'+@DocuNumero    
Update DocumentoVenta    
set DocuAsociado=@DocuId    
where DocuId=@DocuAsociado    
update NotaPedido    
set NotaEstado='ANULADO'    
where NotaId=@NotaId    
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')     
Open Tabla    
Declare @Columna varchar(max),    
  @IdProducto numeric(20),    
  @Cantidad decimal(18,2),    
  @Precio decimal(18,2),    
  @Importe decimal(18,2),    
  @DetalleNotaId numeric(38),    
  @UM varchar(80),    
  @ValorUM decimal(18,4),    
  @StockInicial decimal(18,2),    
  @StockFinal decimal(18,2),@CantidadIng decimal(18,2)    
Declare @p1 int,@p2 int,@p3 int,@p4 int,    
        @p5 int,@p6 int,@p7 int    
Fetch Next From Tabla INTO @Columna    
 While @@FETCH_STATUS = 0    
 Begin    
Set @p1 = CharIndex('|',@Columna,0)    
Set @p2 = CharIndex('|',@Columna,@p1+1)    
Set @p3 = CharIndex('|',@Columna,@p2+1)    
Set @p4 = CharIndex('|',@Columna,@p3+1)    
Set @p5 = CharIndex('|',@Columna,@p4+1)    
Set @p6= CharIndex('|',@Columna,@p5+1)    
Set @p7 = Len(@Columna)+1    
Set @Cantidad=Convert(decimal(18,2),SUBSTRING(@Columna,1,@p1-1))    
Set @UM=SUBSTRING(@Columna,@p1+1,@p2-(@p1+1))    
Set @Precio=Convert(decimal(18,2),SUBSTRING(@Columna,@p2+1,@p3-(@p2+1)))    
Set @Importe=Convert(decimal(18,2),SUBSTRING(@Columna,@p3+1,@p4-(@p3+1)))    
Set @DetalleNotaId=Convert(numeric(38),SUBSTRING(@Columna,@p4+1,@p5-(@p4+1)))    
Set @IdProducto=Convert(numeric(20),SUBSTRING(@Columna,@p5+1,@p6-(@p5+1)))    
Set @ValorUM=Convert(decimal(18,4),SUBSTRING(@Columna,@p6+1,@p7-(@p6+1)))    
insert into DetalleDocumento     
values(@DocuId,@IdProducto,@Cantidad,@Precio,@Importe,@DetalleNotaId,@UM,@ValorUM)  
   
if(@NotaEstado='CANCELADO')    
begin    
 set @StockInicial=(select top 1 ProductoCantidad from Producto(nolock) where IdProducto=@IdProducto)    
 set @CantidadIng=(@Cantidad*@ValorUM)    
 set @StockFinal=@StockInicial+@CantidadIng  
     
 update Producto    
 set ProductoCantidad=ProductoCantidad+@CantidadIng    
 where IdProducto=@IdProducto    
   
 insert into Kardex    
 values(@IdProducto,GETDATE(),'Ingreso por N-Credito',@KardexDocu,@StockInicial,@CantidadIng,0,@Precio,@StockFinal,'INGRESO',@DocuUsuario)    
end    
  
Fetch Next From Tabla INTO @Columna    
end    
 Close Tabla;    
 Deallocate Tabla;   
 delete from CajaDetalle  
 where NotaId=@NotaId  
 Commit Transaction;    
select    
isnull((select STUFF ((select '¬'+convert(varchar,d.DocuId)+'|'+convert(varchar,d.CompaniaId)+'|'+    
convert(varchar,d.NotaId)+'|'+(Convert(char(10),d.DocuEmision,103))+'|'+    
d.DocuDocumento+'|'+d.docuSerie+'-'+d.DocuNumero+'|'+c.ClienteRazon+'|'+c.ClienteRuc+'|'+    
d.DocuNroGuia+'|'+d.DocuNumero+'|'+d.DocuSerie+'|'+    
(convert(varchar(50), CAST(d.DocuSubTotal as money),1))+'|'+    
(convert(varchar(50), CAST(d.DocuIgv as money),1))+'|'+    
(convert(varchar(50), CAST(d.ICBPER as money),1))+'|'+    
(convert(varchar(50), CAST(d.DocuTotal as money),1))+'|'+    
d.DocuUsuario+'|'+d.DocuEstado+'|'+c.ClienteDireccion+'|'+d.DocuAsociado+'|'+    
co.CompaniaRazonSocial+'|'+co.CompaniaRUC+'|'+d.DocuConcepto+'|'+    
(convert(varchar(50), CAST(d.DocuGravada as money),1))+'|'+    
(convert(varchar(50), CAST(d.DocuDescuento as money),1))    
from DocumentoVenta d    
inner join Cliente c    
on c.ClienteId=d.ClienteId    
inner join Compania co    
on co.CompaniaId=d.CompaniaId    
where d.TipoCodigo='07'and (Month(d.DocuEmision)=Month(GETDATE())and year(d.DocuEmision)=YEAR(Getdate()))    
order by d.DocuId desc    
for xml path('')),1,1,'')),'~')    
end
GO
/****** Object:  StoredProcedure [dbo].[uspinsertarNotaB]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspinsertarNotaB]  
@ListaOrden varchar(Max)  
as  
begin  
Declare @pos1 int,@pos2 int,@pos3 int  
Declare @orden varchar(max),  
        @detalle varchar(max),  
        @Guia varchar(max)  
Set @pos1 = CharIndex('[',@ListaOrden,0)  
Set @pos2 = CharIndex('[',@ListaOrden,@pos1+1)  
Set @pos3 =Len(@ListaOrden)+1  
Set @orden = SUBSTRING(@ListaOrden,1,@pos1-1)  
Set @detalle = SUBSTRING(@ListaOrden,@pos1+1,@pos2-@pos1-1)  
Set @Guia=SUBSTRING(@ListaOrden,@pos2+1,@pos3-@pos2-1)  
Declare @c1 int,@c2 int,@c3 int,@c4 int,  
        @c5 int,@c6 int,@c7 int,@c8 int,  
        @c9 int,@c10 int,@c11 int,@c12 int,  
        @c13 int,@c14 int,@c15 int,@c16 int,  
        @c17 int,@c18 int,@c19 int,@c20 int,  
        @c21 int,@c22 int,@c23 int,@c24 int,  
        @c25 int,@c26 int,@c27 int,@c28 int,  
        @c29 int,@c30 int,@c31 int,@c32 int,  
        @c33 int,@c34 int,@c35 int,  
        @c36 int  
Declare   
  @NotaDocu varchar(60),@ClienteId numeric(20),  
  @NotaUsuario varchar(60),@NotaFormaPago varchar(60),  
  @NotaCondicion varchar(60),@NotaDireccion varchar(max),  
  @NotaTelefono varchar(60),@NotaSubtotal decimal (18,2),  
  @NotaMovilidad decimal(18,2),@NotaDescuento decimal (18, 2),  
  @NotaTotal decimal (18,2),@NotaAcuenta decimal(18,2),  
  @NotaSaldo decimal(18,2),@NotaAdicional decimal(18,2),  
  @NotaTarjeta decimal(18,2),@NotaPagar decimal(18,2),  
  @NotaEstado varchar(60),@CompaniaId int,  
  @NotaEntrega varchar(40),@NotaConcepto varchar(60),  
  @Serie char(4),@Numero varchar(60),  
  @NotaGanancia decimal(18,2),@Letra varchar(max),  
  @DocuAdicional decimal(18,2),@DocuHash varchar(250),  
  @EstadoSunat varchar(80),@DocuSubtotal decimal(18,2),  
  @DocuIGV decimal(18,2),@UsuarioId int,@CajaId numeric(38),  
  @Movimiento varchar(40),@Tipotransaccion varchar(20),  
  @NotaTransaccion varchar(250),@KARDEX VARCHAR(1),  
  @Efectivo decimal(18,2),@Vuelto decimal(18,2),  
  @IdOrden varchar(40),@ICBPER decimal(18,2),  
  @DocuGravada decimal(18,2),@DocuDescuento decimal(18,2)  
Set @c1 = CharIndex('|',@orden,0)  
Set @c2 = CharIndex('|',@orden,@c1+1)  
Set @c3 = CharIndex('|',@orden,@c2+1)  
Set @c4 = CharIndex('|',@orden,@c3+1)  
Set @c5 = CharIndex('|',@orden,@c4+1)  
Set @c6= CharIndex('|',@orden,@c5+1)  
Set @c7 = CharIndex('|',@orden,@c6+1)  
Set @c8 = CharIndex('|',@orden,@c7+1)  
Set @c9 = CharIndex('|',@orden,@c8+1)  
Set @c10= CharIndex('|',@orden,@c9+1)  
Set @c11= CharIndex('|',@orden,@c10+1)  
Set @c12= CharIndex('|',@orden,@c11+1)  
Set @c13= CharIndex('|',@orden,@c12+1)  
Set @c14= CharIndex('|',@orden,@c13+1)  
Set @c15= CharIndex('|',@orden,@c14+1)  
Set @c16= CharIndex('|',@orden,@c15+1)  
Set @c17= CharIndex('|',@orden,@c16+1)  
Set @c18 = CharIndex('|',@orden,@c17+1)  
Set @c19 = CharIndex('|',@orden,@c18+1)  
Set @c20= CharIndex('|',@orden,@c19+1)  
Set @c21= CharIndex('|',@orden,@c20+1)  
Set @c22= CharIndex('|',@orden,@c21+1)  
Set @c23= CharIndex('|',@orden,@c22+1)  
Set @c24= CharIndex('|',@orden,@c23+1)  
Set @c25= CharIndex('|',@orden,@c24+1)  
Set @c26= CharIndex('|',@orden,@c25+1)  
Set @c27= CharIndex('|',@orden,@c26+1)  
Set @c28= CharIndex('|',@orden,@c27+1)  
Set @c29= CharIndex('|',@orden,@c28+1)  
Set @c30= CharIndex('|',@orden,@c29+1)  
Set @c31= CharIndex('|',@orden,@c30+1)  
Set @c32= CharIndex('|',@orden,@c31+1)  
Set @c33= CharIndex('|',@orden,@c32+1)  
Set @c34= CharIndex('|',@orden,@c33+1)  
Set @c35= CharIndex('|',@orden,@c34+1)  
Set @c36= Len(@orden)+1  
set @NotaDocu=SUBSTRING(@orden,1,@c1-1)  
set @ClienteId=convert(numeric(20),SUBSTRING(@orden,@c1+1,@c2-@c1-1))  
set @NotaUsuario=SUBSTRING(@orden,@c2+1,@c3-@c2-1)  
set @NotaFormaPago=SUBSTRING(@orden,@c3+1,@c4-@c3-1)  
set @NotaCondicion=SUBSTRING(@orden,@c4+1,@c5-@c4-1)  
set @NotaDireccion=SUBSTRING(@orden,@c5+1,@c6-@c5-1)  
set @NotaTelefono=SUBSTRING(@orden,@c6+1,@c7-@c6-1)  
set @NotaSubtotal=convert(decimal(18,2),SUBSTRING(@orden,@c7+1,@c8-@c7-1))  
set @NotaMovilidad=convert(decimal(18,2),SUBSTRING(@orden,@c8+1,@c9-@c8-1))  
set @NotaDescuento=convert(decimal(18,2),SUBSTRING(@orden,@c9+1,@c10-@c9-1))  
set @NotaTotal=convert(decimal(18,2),SUBSTRING(@orden,@c10+1,@c11-@c10-1))  
set @NotaAcuenta=convert(decimal(18,2),SUBSTRING(@orden,@c11+1,@c12-@c11-1))  
set @NotaSaldo=convert(decimal(18,2),SUBSTRING(@orden,@c12+1,@c13-@c12-1))  
set @NotaAdicional=convert(decimal(18,2),SUBSTRING(@orden,@c13+1,@c14-@c13-1))  
set @NotaTarjeta=convert(decimal(18,2),SUBSTRING(@orden,@c14+1,@c15-@c14-1))  
set @NotaPagar=convert(decimal(18,2),SUBSTRING(@orden,@c15+1,@c16-@c15-1))  
set @NotaEstado=SUBSTRING(@orden,@c16+1,@c17-@c16-1)  
set @CompaniaId=convert(int,SUBSTRING(@orden,@c17+1,@c18-@c17-1))  
set @NotaEntrega=SUBSTRING(@orden,@c18+1,@c19-@c18-1)  
set @NotaConcepto=SUBSTRING(@orden,@c19+1,@c20-@c19-1)  
set @Serie=convert(char(4),SUBSTRING(@orden,@c20+1,@c21-@c20-1))  
set @Numero=SUBSTRING(@orden,@c21+1,@c22-@c21-1)  
set @NotaGanancia=convert(decimal(18,2),SUBSTRING(@orden,@c22+1,@c23-@c22-1))  
set @Letra=SUBSTRING(@orden,@c23+1,@c24-@c23-1)  
set @DocuAdicional=convert(decimal(18,2),SUBSTRING(@orden,@c24+1,@c25-@c24-1))  
set @DocuHash=SUBSTRING(@orden,@c25+1,@c26-@c25-1)  
set @EstadoSunat=SUBSTRING(@orden,@c26+1,@c27-@c26-1)  
set @DocuSubtotal=convert(decimal(18,2),SUBSTRING(@orden,@c27+1,@c28-@c27-1))  
set @DocuIGV=convert(decimal(18,2),SUBSTRING(@orden,@c28+1,@c29-@c28-1))  
set @UsuarioId=convert(int,SUBSTRING(@orden,@c29+1,@c30-@c29-1))  
set @Efectivo=convert(decimal(18,2),SUBSTRING(@orden,@c30+1,@c31-@c30-1))  
set @Vuelto=convert(decimal(18,2),SUBSTRING(@orden,@c31+1,@c32-@c31-1))  
set @IdOrden=SUBSTRING(@orden,@c32+1,@c33-@c32-1)  
set @ICBPER=convert(decimal(18,2),SUBSTRING(@orden,@c33+1,@c34-@c33-1))  
set @DocuGravada=convert(decimal(18,2),SUBSTRING(@orden,@c34+1,@c35-@c34-1))  
set @DocuDescuento=convert(decimal(18,2),SUBSTRING(@orden,@c35+1,@c36-@c35-1))  
set @CajaId=isnull((select top 1 CajaId from Caja where CajaEstado='ACTIVO'   
and UsuarioId=@UsuarioId order by 1 desc),'0')  
if(@CajaId=0)  
begin  
select 'false'  
end  
else  
begin  
if(@NotaDocu='FACTURA')set @NotaEstado='PENDIENTE'  
else if(@NotaDocu='PROFORMA')set @NotaEstado='PENDIENTE'  
else  
begin  
   set @NotaEstado='CANCELADO'  
   set @NotaSaldo=0  
   set @NotaAcuenta=@NotaPagar  
end  
if(@NotaFormaPago='EFECTIVO')set @Movimiento='INGRESO'  
else set @Movimiento='TARJETA'   
declare @NotaId numeric(38),  
        @DocuId numeric(38)=0  
Begin Transaction  
update Cliente  
set ClienteDespacho=@NotaDireccion,ClienteTelefono=@NotaTelefono  
where ClienteId=@ClienteId  
delete from TemporalVenta   
where UsuarioID=@UsuarioId  
declare @cod varchar(13)  
SET @cod=isnull((select TOP 1 dbo.genenerarNroFactura(@Serie,@CompaniaId,@NotaDocu) AS ID   
FROM DocumentoVenta),'00000001')  
insert into NotaPedido values(@NotaDocu,@ClienteId,GETDATE(),@NotaUsuario,  
@NotaFormaPago,@NotaCondicion,1,GETDATE(),@NotaDireccion,@NotaTelefono,  
@NotaSubtotal,@NotaMovilidad,@NotaDescuento,@NotaTotal,@NotaAcuenta,@NotaSaldo,  
@NotaAdicional,@NotaTarjeta,@NotaPagar,@NotaEstado,@CompaniaId,  
@NotaEntrega,'','',@NotaConcepto,@Serie,@cod,@NotaGanancia,@CajaId,@Efectivo,@Vuelto,@ICBPER)  
set @NotaId=(select @@IDENTITY)  
if @NotaDocu='PROFORMA V'  
begin  
insert into DocumentoVenta values  
(@CompaniaId,@NotaId,'PROFORMA V',@cod,@ClienteId,GETDATE(),  
GETDATE(),@NotaCondicion,cast(convert(date,GETDATE()) as varchar(10)),  
@Letra,@DocuSubtotal,@DocuIGV,@NotaPagar,0,@NotaUsuario,'EMITIDO',@Serie,'00',  
@DocuAdicional,'','VENTA','',@DocuHash,'ENVIADO','','',@ICBPER,@DocuGravada,@DocuDescuento)  
set @DocuId=(select @@IDENTITY)  
insert into CajaDetalle values(@CajaId,GETDATE(),@NotaId,@Movimiento,'',  
'Transacción con '+@NotaFormaPago,'SOLES',0,@NotaPagar,@Efectivo,@Vuelto)  
SET @KARDEX='S'  
end  
else if @NotaDocu='BOLETA'  
begin  
insert into DocumentoVenta values  
(@CompaniaId,@NotaId,'BOLETA',@cod,@ClienteId,GETDATE(),  
GETDATE(),@NotaCondicion,cast(convert(date,GETDATE()) as varchar(10)),  
@Letra,@DocuSubtotal,@DocuIGV,@NotaPagar,0,@NotaUsuario,'EMITIDO',@Serie,'03',  
@DocuAdicional,'','VENTA','',@DocuHash,@EstadoSunat,'','',@ICBPER,@DocuGravada,@DocuDescuento)  
set @DocuId=(select @@IDENTITY)  
if(@NotaConcepto='MERCADERIA')  
begin  
insert into CajaDetalle values(@CajaId,GETDATE(),@NotaId,@Movimiento,'',  
'Transacción con '+@NotaFormaPago,'SOLES',0,@NotaPagar,@Efectivo,@Vuelto)  
SET @KARDEX='S'  
end  
end  
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')   
Open Tabla  
Declare @Columna varchar(max),  
  @IdProducto numeric(20),  
  @DetalleCantidad decimal(18,2),  
  @DetalleUm varchar(40),  
  @Descripcion varchar(140),  
  @DetalleCosto decimal(18,2),   
  @DetallePrecio decimal(18,2),  
  @DetalleImporte decimal(18,2),  
  @DetalleEstado varchar(60),  
  @ValorUM decimal(18,4),@CantidadSaldo decimal(18,2),  
  @IniciaStock decimal(18,2),@StockFinal decimal(18,2)  
Declare @p1 int,@p2 int,@p3 int,@p4 int,  
        @p5 int,@p6 int,@p7 int,@p8 int,  
        @p9 int  
Fetch Next From Tabla INTO @Columna  
 While @@FETCH_STATUS = 0  
 Begin  
Set @p1 = CharIndex('|',@Columna,0)  
Set @p2 = CharIndex('|',@Columna,@p1+1)  
Set @p3 = CharIndex('|',@Columna,@p2+1)  
Set @p4 = CharIndex('|',@Columna,@p3+1)  
Set @p5 = CharIndex('|',@Columna,@p4+1)  
Set @p6= CharIndex('|',@Columna,@p5+1)  
Set @p7= CharIndex('|',@Columna,@p6+1)  
Set @p8 = CharIndex('|',@Columna,@p7+1)  
Set @p9=Len(@Columna)+1  
set @IdProducto=Convert(numeric(20),SUBSTRING(@Columna,1,@p1-1))  
Set @DetalleCantidad=convert(decimal(18,2),SUBSTRING(@Columna,@p1+1,@p2-(@p1+1)))  
Set @DetalleUm=SUBSTRING(@Columna,@p2+1,@p3-(@p2+1))  
Set @Descripcion=SUBSTRING(@Columna,@p3+1,@p4-(@p3+1))  
Set @DetalleCosto=convert(decimal(18,2),SUBSTRING(@Columna,@p4+1,@p5-(@p4+1)))  
Set @DetallePrecio=convert(decimal(18,2),SUBSTRING(@Columna,@p5+1,@p6-(@p5+1)))  
Set @DetalleImporte=convert(decimal(18,2),SUBSTRING(@Columna,@p6+1,@p7-(@p6+1)))  
Set @DetalleEstado=SUBSTRING(@Columna,@p7+1,@p8-(@p7+1))
  
if(@NotaEntrega='INMEDIATA')Set @CantidadSaldo=0  
else Set @CantidadSaldo=@DetalleCantidad  
set @ValorUM=convert(decimal(18,4),SUBSTRING(@Columna,@p8+1,@p9-(@p8+1)))  

insert into DetallePedido values(@NotaId,@IdProducto,@DetalleCantidad,  
@DetalleUm,@Descripcion,@DetalleCosto, @DetallePrecio,  
@DetalleImporte,@DetalleEstado,@CantidadSaldo,@ValorUM)  
if(@DocuId<>0)  
begin  
insert into DetalleDocumento values  
(@DocuId,@IdProducto,@DetalleCantidad,@DetallePrecio,@DetalleImporte,  
@NotaId,@DetalleUm,@ValorUM)  
end  
if(@KARDEX='S')  
BEGIN
 
 set @DetalleCantidad =@DetalleCantidad * @ValorUM
 
 set @IniciaStock=(select top 1 ProductoCantidad from Producto where IdProducto=@IdProducto)  
 set @StockFinal=@IniciaStock-@DetalleCantidad  
 
 insert into Kardex values(@IdProducto,GETDATE(),'Salida por Venta',@Serie+'-'+@cod,@IniciaStock,  
 0,@DetalleCantidad,@DetalleCosto,@StockFinal,'SALIDA',@NotaUsuario)  
 
 update producto   
 set  ProductoCantidad =ProductoCantidad - @DetalleCantidad  
 where IDProducto=@IdProducto  

end  
Fetch Next From Tabla INTO @Columna  
end  
 Close Tabla;  
 Deallocate Tabla;  
declare @Mesas varchar(max)  
set @Mesas=isnull((select STUFF ((select ';'+Convert(varchar,id_mesa)  
from Combinacion_Mesas   
where IdOrden=@IdOrden  
for xml path('')),1,1,'')),'0')  
---------------   
if(len(@Mesas)>0)  
begin  
Declare TablaB Cursor For Select * From fnSplitString(@Mesas,';')   
Open TablaB  
Declare @ColumnaB varchar(max),  
        @id_mesa int  
Declare @g1 int  
Fetch Next From TablaB INTO @ColumnaB  
 While @@FETCH_STATUS = 0  
 Begin  
Set @g1=Len(@ColumnaB)+1  
set @id_mesa=Convert(int,SUBSTRING(@ColumnaB,1,@g1-1))  
update tbl_mesa  
set estado='LIBRE'  
where id_mesa=@id_mesa  
Fetch Next From TablaB INTO @ColumnaB  
end  
 Close TablaB;  
 Deallocate TablaB;  
 update Tbl_Orden_Pedido  
    set Estado='CANCELADO'  
    where IdOrden=@IdOrden  
    Commit Transaction;  
    select convert(varchar,@NotaId)+'¬'+@cod  
end  
else  
begin  
 update Tbl_Orden_Pedido  
    set Estado='CANCELADO'  
    where IdOrden=@IdOrden  
    Commit Transaction;  
    select convert(varchar,@NotaId)+'¬'+@cod  
end  
end  
end
GO
/****** Object:  StoredProcedure [dbo].[uspinsertarRB]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspinsertarRB]  
@ListaOrden varchar(Max)  
as  
begin  
Declare @pos int  
Declare @orden varchar(max)  
Declare @detalle varchar(max)  
Set @pos = CharIndex('[',@ListaOrden,0)  
Set @orden = SUBSTRING(@ListaOrden,1,@pos-1)  
Set @detalle = SUBSTRING(@ListaOrden,@pos+1,len(@ListaOrden)-@pos)  
Declare @c1 int,@c2 int,@c3 int,@c4 int,  
        @c5 int,@c6 int,@c7 int,@c8 int,  
        @c9 int,@c10 int,@c11 int,@c12 int,  
        @c13 int,@c14 INT  
Declare @CompaniaId int,@ResumenSerie varchar(250),  
@Secuencia numeric(38),@FechaReferencia date,  
@SubTotal decimal(18,2),@IGV decimal(18,2),  
@Total decimal(18,2),@ResumenTiket varchar(250),  
@CodigoSunat  varchar(80),@HASHCDR   varchar(max),  
@Usuario varchar(80),@Status int,@Estado char(1),  
@RangoNumero varchar(80),@ICBPER decimal(18,2)  
Set @c1 = CharIndex('|',@orden,0)  
Set @c2 = CharIndex('|',@orden,@c1+1)  
Set @c3 = CharIndex('|',@orden,@c2+1)  
Set @c4 = CharIndex('|',@orden,@c3+1)  
Set @c5 = CharIndex('|',@orden,@c4+1)  
Set @c6= CharIndex('|',@orden,@c5+1)  
Set @c7 = CharIndex('|',@orden,@c6+1)  
Set @c8 = CharIndex('|',@orden,@c7+1)  
Set @c9 = CharIndex('|',@orden,@c8+1)  
Set @c10= CharIndex('|',@orden,@c9+1)  
Set @c11= CharIndex('|',@orden,@c10+1)  
Set @c12= CharIndex('|',@orden,@c11+1)  
Set @c13= CharIndex('|',@orden,@c12+1)  
Set @c14= Len(@orden)+1  
Set @CompaniaId=convert(int,SUBSTRING(@orden,1,@c1-1))  
Set @ResumenSerie=SUBSTRING(@orden,@c1+1,@c2-@c1-1)  
Set @Secuencia=convert(int,SUBSTRING(@orden,@c2+1,@c3-@c2-1))  
set @FechaReferencia=convert(date,SUBSTRING(@orden,@c3+1,@c4-@c3-1))  
set @SubTotal=convert(decimal(18,2),SUBSTRING(@orden,@c4+1,@c5-@c4-1))  
set @IGV=convert(decimal(18,2),SUBSTRING(@orden,@c5+1,@c6-@c5-1))  
set @Total=convert(decimal(18,2),SUBSTRING(@orden,@c6+1,@c7-@c6-1))  
set @ResumenTiket=SUBSTRING(@orden,@c7+1,@c8-@c7-1)  
set @CodigoSunat=SUBSTRING(@orden,@c8+1,@c9-@c8-1)  
set @HASHCDR=SUBSTRING(@orden,@c9+1,@c10-@c9-1)  
set @Usuario=SUBSTRING(@orden,@c10+1,@c11-@c10-1)  
set @Status=SUBSTRING(@orden,@c11+1,@c12-@c11-1)  
set @RangoNumero=SUBSTRING(@orden,@c12+1,@c13-@c12-1)  
set @ICBPER=SUBSTRING(@orden,@c13+1,@c14-@c13-1)  
if(@Status=3)  
begin  
set @SubTotal=0-@SubTotal  
set @IGV=0-@IGV  
set @ICBPER=0-@ICBPER  
set @Total=0-@Total  
set @Estado='B'--BAJA  
end  
else  
begin  
set @Estado='E'--ENVIADO  
end  
Begin Transaction  
insert into ResumenBoletas values  
(@CompaniaId,@ResumenSerie,@Secuencia,@FechaReferencia,Getdate(),  
@SubTotal,@IGV,@Total,@ResumenTiket,@CodigoSunat,@HASHCDR,'',@Usuario,  
@Estado,@RangoNumero,@ICBPER)  
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')   
Open Tabla  
Declare @Columna varchar(max),  
        @DocuId numeric(38)  
Declare @p1 int  
Fetch Next From Tabla INTO @Columna  
 While @@FETCH_STATUS = 0  
 Begin  
Set @p1 = Len(@Columna)+1  
Set @DocuId=Convert(numeric(38),SUBSTRING(@Columna,1,@p1-1))  
if(@Status=1)--Declarar 3 Anular  
begin  
update DocumentoVenta  
set DocuHash=@HASHCDR,EstadoSunat='ENVIADO'  
where DocuId=@DocuId  
end  
else  
begin  
update DocumentoVenta  
set DocuHash=@HASHCDR,DocuEstado='BAJA',EstadoSunat='ENVIADO',  
DocuSubTotal=0,DocuIgv=0,DocuTotal=0,ICBPER=0  
where DocuId=@DocuId  
end  
Fetch Next From Tabla INTO @Columna  
end  
 Close Tabla;  
 Deallocate Tabla;  
 Commit Transaction;  
SELECT  
isnull((select STUFF ((select '¬'+convert(varchar,r.ResumenId)+'|'+convert(varchar,r.CompaniaId)+'|'+  
(IsNull(convert(varchar,r.FechaReferencia,103),''))+'|'+  
(IsNull(convert(varchar,r.FechaEnvio,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,r.FechaEnvio,114),1,8),''))+'|'+  
r.ResumenSerie+'-'+convert(varchar,r.Secuencia)+'|'+r.RangoNumero+'|'+  
CONVERT(VarChar(50),cast(r.SubTotal as money ), 1)+'|'+  
CONVERT(VarChar(50),cast( r.IGV as money ), 1)+'|'+  
CONVERT(VarChar(50),cast( r.ICBPER as money ), 1)+'|'+  
CONVERT(VarChar(50),cast(r.Total as money ), 1)+'|'+  
r.ResumenTiket+'|'+r.CodigoSunat+'|'+r.HASHCDR+'|'+r.MensajeSunat+'|'+  
r.Usuario+'|'+c.CompaniaRUC+'|'+  
c.CompaniaUserSecun+'|'+c.ComapaniaPWD+'|'+r.Estado+'||'+c.TokenApi+'|'+ClienIdToken  
FROM ResumenBoletas r  
inner join Compania c  
on c.CompaniaId=r.CompaniaId  
where Month(r.FechaReferencia)=MONTH(Getdate()) and YEAR(r.FechaReferencia)=year(Getdate())  
order by r.CompaniaId,r.FechaEnvio asc  
for xml path('')),1,1,'')),'~')  
end
GO
/****** Object:  StoredProcedure [dbo].[uspinsertaSeries]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspinsertaSeries]
@detalle varchar(max)
as
Begin Transaction
Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
		Declare @Columna varchar(max)
Declare @p1 int,@p2 int,
        @p3 int,@p4 int
Declare @UsuarioID int,@UsuarioSerie varchar(4),
        @EnviaBoleta Bit,@EnviarFactura Bit,@B int,@F int
	Fetch Next From Tabla INTO @Columna
	While @@FETCH_STATUS = 0
	Begin
Set @p1 = CharIndex('|',@Columna,0)
Set @p2 = CharIndex('|',@Columna,@p1+1)
Set @p3 = CharIndex('|',@Columna,@p2+1)  
Set @p4 = Len(@Columna)+1 
Set @UsuarioID=convert(int,SUBSTRING(@Columna,1,@p1-1))
Set @UsuarioSerie=SUBSTRING(@Columna,@p1+1,@p2-@p1-1) 
Set @EnviaBoleta=SUBSTRING(@Columna,@p2+1,@p3-@p2-1)
Set @EnviarFactura=SUBSTRING(@Columna,@p3+1,@p4-@p3-1)
if(@EnviaBoleta='False')set @B=0
else set @B=1
if(@EnviarFactura='False')set @f=0
else set @f=1
update Usuarios
set UsuarioSerie=@UsuarioSerie,EnviaBoleta=@B,EnviarFactura=@F
where UsuarioID=@UsuarioID
Fetch Next From Tabla INTO @Columna
	end
	Close Tabla;
	Deallocate Tabla;
	Commit Transaction;
	Select 'true';
GO
/****** Object:  StoredProcedure [dbo].[uspListaBajas]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspListaBajas]  
@Data varchar(max)  
as  
begin  
Declare @p1 int  
Declare @CompaniaId int  
Set @Data = LTRIM(RTrim(@Data))  
set @CompaniaId=@Data  
select  
'DocuId|Compania|NotaId|FechaEmision|Documento|Numero|RazonSocial|DNI|SubTotal|IGV|ICBPER|Total|Usuario|Estado¬100|80|100|115|95|130|350|90|115|115|100|115|160|125¬String|String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+  
isnull((select STUFF((select '¬'+convert(varchar,d.DocuId)+'|'+convert(varchar,d.CompaniaId)+'|'+convert(varchar,d.NotaId)+'|'+  
(Convert(char(10),d.DocuEmision,103))+'|'+d.DocuDocumento+'|'+d.docuSerie+'-'+d.DocuNumero+'|'+  
c.ClienteRazon+'|'+c.ClienteDni+'|'+  
(convert(varchar(50), CAST(d.DocuSubTotal as money), -1))+'|'+  
(convert(varchar(50), CAST(d.DocuIgv as money), -1))+'|'+  
(convert(varchar(50), CAST(d.ICBPER as money), -1))+'|'+  
(convert(varchar(50), CAST(d.DocuTotal as money), -1))+'|'+  
d.DocuUsuario+'|'+d.EstadoSunat  
from DocumentoVenta d  
inner join Cliente c  
on c.ClienteId=d.ClienteId  
where d.TipoCodigo='03'and((d.CompaniaId=@CompaniaId and DocuEstado='ANULADO' and EstadoSunat='ENVIADO'))  
order by d.DocuSerie,d.DocuNumero asc  
FOR XML path ('')),1,1,'')),'~')  
end
GO
/****** Object:  StoredProcedure [dbo].[usplistaDetalleApertura]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usplistaDetalleApertura]
@IdApertura varchar(38)
as
begin
select
isnull((select STUFF((select '¬'+ convert(varchar,d.DetalleId)+'|'+
d.Descripcion+'|'+convert(varchar,convert(int,d.Ingreso))+'|'+d.DeIngreso+'|'+
convert(varchar,convert(int,d.Cierre))+'|'+d.DeCierre+'|'+d.Total
from DetalleApertura d
where d.IdApertura=@IdApertura
order by d.DetalleId asc
FOR XML PATH('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[usplistaDetalleOrden]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usplistaDetalleOrden]
@IdOrden numeric(38)
as
begin
Declare @Mozo varchar(80)
set @Mozo=(select top 1 t.Usuario 
from Tbl_Orden_Pedido t where t.IdOrden=@IdOrden)
select
'TemporalId|UsuarioId|IdProducto|Codigo|Cantidad|UM|Descripcion|PrecioCosto|PrecioUni|Importe|Imagen|ValorUM|PrecioSunat|IGVPrecio|ImporteSunat¬100|100|100|100|100|100|100|100|100|100|100|100|100|100|100¬String|String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+
    isnull((select STUFF ((select '¬'+convert(varchar,t.DetalleId)+'||'+convert(varchar,t.IdProducto)+'|'+
    p.ProductoCodigo+'|'+convert(varchar,t.cantidad)+'|'+p.ProductoUM+'|'+p.ProductoNombre+'|'+
	convert(varchar,cast((p.ProductoCosto* 1) as decimal(18,2)))+'|'+
	convert(varchar,t.PrecioUni)+'|'+
	CONVERT(VarChar(50), cast(t.importe as money ), 1)+'|'+
	p.ProductoImagen+'|1|'+
	convert(varchar,convert(decimal(18,2),t.PrecioUni/1.18))+'|'+
	convert(varchar,(t.importe - convert(decimal(18,2),t.importe/1.18)))+'|'+
	convert(varchar,convert(decimal(18,2),t.importe/1.18))
	from Tbl_Detalle_Orden t
	inner join Producto p
	on p.IdProducto=t.IdProducto
	where t.IdOrden=@IdOrden
	order by t.DetalleId asc
	for xml path('')),1,1,'')),'~')+'['+@Mozo
	end
GO
/****** Object:  StoredProcedure [dbo].[uspListaDocumentos]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uspListaDocumentos]  
@Data varchar(max)  
as  
begin  
Declare @p1 int  
Declare @CompaniaId int  
declare @fechaReferencia date  
Set @Data = LTRIM(RTrim(@Data))  
set @CompaniaId=@Data  
set @fechaReferencia=(select top 1 DocuEmision from DocumentoVenta  
where TipoCodigo='03'and((CompaniaId=@CompaniaId and EstadoSunat='PENDIENTE') and DocuEmision<convert(date,GETDATE()))  
group by DocuEmision  
order by DocuEmision asc)  
select  
'DocuId|Compania|NotaId|FechaEmision|Documento|Numero|RazonSocial|DNI|SubTotal|IGV|ICBPER|Total|Usuario|Estado¬100|80|100|115|95|130|350|90|115|115|100|115|160|125¬String|String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+  
isnull((select STUFF((select '¬'+convert(varchar,d.DocuId)+'|'+convert(varchar,d.CompaniaId)+'|'+convert(varchar,d.NotaId)+'|'+  
(Convert(char(10),d.DocuEmision,103))+'|'+d.DocuDocumento+'|'+d.docuSerie+'-'+d.DocuNumero+'|'+  
c.ClienteRazon+'|'+c.ClienteDni+'|'+  
(convert(varchar(50), CAST(d.DocuSubTotal as money), -1))+'|'+  
(convert(varchar(50), CAST(d.DocuIgv as money), -1))+'|'+  
(convert(varchar(50), CAST(d.ICBPER as money), -1))+'|'+  
(convert(varchar(50), CAST(d.DocuTotal as money), -1))+'|'+  
d.DocuUsuario+'|'+d.EstadoSunat  
from DocumentoVenta d  
inner join Cliente c  
on c.ClienteId=d.ClienteId  
where d.TipoCodigo='03'and((d.CompaniaId=@CompaniaId and EstadoSunat='PENDIENTE') and d.DocuEmision=@fechaReferencia)  
order by d.DocuSerie,d.DocuNumero asc  
FOR XML path ('')),1,1,'')),'~')  
end  
GO
/****** Object:  StoredProcedure [dbo].[uspListaFacturaPendiente]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspListaFacturaPendiente]  
as  
begin  
select   
'DocuID|NotaId|FechaEmision|Documento|Numero|Cliente|RUC|Descuento|SubTotal|IGV|ICBPER|Total|Usuario|Compania|Movilidad|Adicional|TipoCodigo|Serie|Nro|Forma¬90|100|100|100|130|350|100|100|110|110|90|110|150|90|90|90|90|90|90|90¬String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+  
isnull((select STUFF ((select '¬'+convert(varchar,d.DocuId)+'|'+convert(varchar,d.NotaId)+'|'+  
Convert(char(10),d.DocuEmision,103)+'|'+d.DocuDocumento+'|'+  
d.DocuSerie+'-'+d.DocuNumero+'|'+cl.ClienteRazon+'|'+cl.ClienteRuc+'|'+  
CONVERT(VarChar(50), cast(n.NotaDescuento as money ), 1)+'|'+  
CONVERT(VarChar(50), cast(d.DocuSubTotal as money ), 1)+'|'+  
CONVERT(VarChar(50), cast(d.DocuIgv as money ), 1)+'|'+  
CONVERT(VarChar(50), cast(d.ICBPER as money ), 1)+'|'+  
CONVERT(VarChar(50), cast(d.DocuTotal as money ), 1)+'|'+d.DocuUsuario+'|'+c.CompaniaRazonSocial+'|'+  
CONVERT(VarChar(50), cast(n.NotaMovilidad as money ), 1)+'|'+  
CONVERT(VarChar(50), cast(n.NotaAdicional as money ), 1)+'|'+  
LTRIM(RTrim(d.TipoCodigo))+'|'+d.DocuSerie+'|'+d.DocuNumero+'|'+  
n.NotaFormaPago  
from DocumentoVenta d  
inner join NotaPedido n  
on n.NotaId=d.NotaId  
inner join Cliente cl  
on cl.ClienteId=d.ClienteId  
inner join Compania c  
on c.CompaniaId=d.CompaniaId  
where d.EstadoSunat='PENDIENTE' and (d.TipoCodigo='01' or d.TipoCodigo='07')  
order by d.CompaniaId,d.DocuEmision asc  
for xml path('')),1,1,'')),'~')  
end
GO
/****** Object:  StoredProcedure [dbo].[usplistaOrdenPedido]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usplistaOrdenPedido]
as
begin
select
'IdOrden|NroTicket|FechaEmision|HoraFin|ClienteId|Cliente|NroMesas|Observaciones|Usuario|Total|Estado¬90|130|140|100|80|255|250|250|170|110|115¬String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+convert(varchar,o.IdOrden)+'|'+o.OrdenSerie+'-'+o.OrdenNumero+'|'+
IsNull(convert(varchar,o.FechaOrden,103),'')+'  '+
IsNull(SUBSTRING(convert(varchar,o.FechaOrden,114),1,8),'')+'|'+
IsNull(SUBSTRING(convert(varchar,o.HoraFin,114),1,8),'')+'|'+
convert(varchar,c.ClienteId)+'|'+c.ClienteRazon+'|'+o.NroMesas+'|'+o.Observaciones+'|'+o.Usuario+'|'+
CONVERT(VarChar(50), cast(o.Total as money ), 1)+'|'+o.Estado
from Tbl_Orden_Pedido o
inner join Cliente c
on c.ClienteId=o.ClienteId
where o.NroMesas='' --and --o.estado<> 'ANULADO'
order by o.IdOrden desc
FOR XML path ('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[usplistarApertura]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usplistarApertura]
@fechainicio date,
@fechafin date
as
select 'ID|Apertura|Cierre|Usuario|Estado¬90|140|150|160|120¬String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+ convert(varchar,a.IdApertura)+'|'+
Convert(char(10),a.FechaApertura,103)+'|'+
(IsNull(convert(varchar,a.FechaCierre,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,a.FechaCierre,114),1,8),''))+'|'+
a.Usuario+'|'+a.Estado
from AperturaInsumos a
where (Convert(char(10),a.FechaApertura,103) BETWEEN @fechainicio AND @fechafin)
order by a.IdApertura desc
FOR XML PATH('')),1,1,'')),'~')
GO
/****** Object:  StoredProcedure [dbo].[usplistaResumen]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usplistaResumen]  
@Data varchar(max)  
as  
begin  
Declare @p1 int,@p2 int  
Declare @MES INT,@ANNO INT  
Set @Data = LTRIM(RTrim(@Data))  
Set @p1 = CharIndex('|',@Data,0)  
Set @p2= Len(@Data)+1  
Set @MES=convert(int,SUBSTRING(@Data,1,@p1-1))  
Set @ANNO=convert(int,SUBSTRING(@Data,@p1+1,@p2-@p1-1))  
SELECT  
'Id|Compania|FechaEmision|FechaEnvio|Serie|RangoNumeros|SubTotal|IGV|ICBPER|Total|Ticket|CDSunat|HASHCDR|Mensaje|Usuario|RUC|UserSol|ClaveSol|ESTADO|Intentos|TokenApi|IdToken¬100|100|100|100|100|100|100|100|110|110|110|100|100|100|100|100|100|100|100|100|100|100¬String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+   
isnull((select STUFF ((select '¬'+convert(varchar,r.ResumenId)+'|'+convert(varchar,r.CompaniaId)+'|'+  
(IsNull(convert(varchar,r.FechaReferencia,103),''))+'|'+  
(IsNull(convert(varchar,r.FechaEnvio,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,r.FechaEnvio,114),1,8),''))+'|'+  
r.ResumenSerie+'-'+convert(varchar,r.Secuencia)+'|'+r.RangoNumero+'|'+  
CONVERT(VarChar(50),cast(r.SubTotal as money ), 1)+'|'+  
CONVERT(VarChar(50),cast( r.IGV as money ), 1)+'|'+  
CONVERT(VarChar(50),cast( r.ICBPER as money ), 1)+'|'+  
CONVERT(VarChar(50),cast(r.Total as money ), 1)+'|'+  
r.ResumenTiket+'|'+r.CodigoSunat+'|'+r.HASHCDR+'|'+r.MensajeSunat+'|'+  
r.Usuario+'|'+c.CompaniaRUC+'|'+  
c.CompaniaUserSecun+'|'+c.ComapaniaPWD+'|'+r.Estado+'||'+c.TokenApi+'|'+ClienIdToken  
FROM ResumenBoletas r  
inner join Compania c  
on c.CompaniaId=r.CompaniaId  
where Month(r.FechaReferencia)=@MES and YEAR(r.FechaReferencia)=@ANNO  
order by r.CompaniaId,r.FechaEnvio asc  
for xml path('')),1,1,'')),'~')  
end
GO
/****** Object:  StoredProcedure [dbo].[uspListarMesas]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspListarMesas]
As
select
'ID|NroMesa|Capacidad|Ubicacion|Estado¬30|100|80|180|80¬String|String|String|String|String¬'+
isnull((Select STUFF((Select '¬' + convert(varchar,id_mesa) + '|' + nro_mesa + '|' + 
convert(varchar,capacidad) + '|' + ubicacion + '|' + estado
From tbl_mesa
order by nro_mesa desc
FOR XML PATH('')), 1, 1, '')),'~')
GO
/****** Object:  StoredProcedure [dbo].[uspListarMesasMenuPrincipal]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspListarMesasMenuPrincipal]
As
(Select STUFF((Select '¬' + convert(varchar,id_mesa) + '|' + nro_mesa + '|' + 
convert(varchar,capacidad) + '|' + ubicacion + '|' + estado
From tbl_mesa
order by nro_mesa asc
FOR XML PATH('')), 1, 1, ''))
GO
/****** Object:  StoredProcedure [dbo].[usplistarNC]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usplistarNC]
as
begin
select
'DocuId|Compania|NroNota|FechaEmision|Documento|Numero|RazonSocial|RUC|Referencia|Nro|Serie|SubTotal|IGV|ICBPER|Total|Usuario|Estado|Direccion|Asociado|CompaniaRazon|CompaniaRUC|Concepto|Gravada|Descuento¬100|80|100|110|115|120|340|105|120|100|100|115|115|90|115|150|130|100|100|100|100|220|100|100¬String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF ((select '¬'+convert(varchar,d.DocuId)+'|'+convert(varchar,d.CompaniaId)+'|'+
convert(varchar,d.NotaId)+'|'+(Convert(char(10),d.DocuEmision,103))+'|'+
d.DocuDocumento+'|'+d.docuSerie+'-'+d.DocuNumero+'|'+c.ClienteRazon+'|'+c.ClienteRuc+'|'+
d.DocuNroGuia+'|'+d.DocuNumero+'|'+d.DocuSerie+'|'+
(convert(varchar(50), CAST(d.DocuSubTotal as money),1))+'|'+
(convert(varchar(50), CAST(d.DocuIgv as money),1))+'|'+
(convert(varchar(50), CAST(d.ICBPER as money),1))+'|'+
(convert(varchar(50), CAST(d.DocuTotal as money),1))+'|'+
d.DocuUsuario+'|'+d.DocuEstado+'|'+c.ClienteDireccion+'|'+d.DocuAsociado+'|'+
co.CompaniaRazonSocial+'|'+co.CompaniaRUC+'|'+d.DocuConcepto+'|'+
(convert(varchar(50), CAST(d.DocuGravada as money),1))+'|'+
(convert(varchar(50), CAST(d.DocuDescuento as money),1))
from DocumentoVenta d
inner join Cliente c
on c.ClienteId=d.ClienteId
inner join Compania co
on co.CompaniaId=d.CompaniaId
where d.TipoCodigo='07'and (Month(d.DocuEmision)=Month(GETDATE())and year(d.DocuEmision)=YEAR(Getdate()))
order by d.DocuId desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[usplistarNCFecha]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usplistarNCFecha]
@fechainicio date,
@fechafin date
as
begin
select
'DocuId|Compania|NroNota|FechaEmision|Documento|Numero|RazonSocial|RUC|Referencia|Nro|Serie|SubTotal|IGV|ICBPER|Total|Usuario|Estado|Direccion|Asociado|CompaniaRazon|CompaniaRUC|Concepto|Gravada|Descuento¬100|80|100|110|115|120|340|105|120|100|100|115|115|90|115|150|130|100|100|100|100|220|100|100¬String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String|String¬'+
isnull((select STUFF ((select '¬'+convert(varchar,d.DocuId)+'|'+convert(varchar,d.CompaniaId)+'|'+
convert(varchar,d.NotaId)+'|'+(Convert(char(10),d.DocuEmision,103))+'|'+
d.DocuDocumento+'|'+d.docuSerie+'-'+d.DocuNumero+'|'+c.ClienteRazon+'|'+c.ClienteRuc+'|'+
d.DocuNroGuia+'|'+d.DocuNumero+'|'+d.DocuSerie+'|'+
(convert(varchar(50), CAST(d.DocuSubTotal as money),1))+'|'+
(convert(varchar(50), CAST(d.DocuIgv as money),1))+'|'+
(convert(varchar(50), CAST(d.ICBPER as money),1))+'|'+
(convert(varchar(50), CAST(d.DocuTotal as money),1))+'|'+
d.DocuUsuario+'|'+d.DocuEstado+'|'+c.ClienteDireccion+'|'+d.DocuAsociado+'|'+
co.CompaniaRazonSocial+'|'+co.CompaniaRUC+'|'+d.DocuConcepto+'|'+
(convert(varchar(50), CAST(d.DocuGravada as money),1))+'|'+
(convert(varchar(50), CAST(d.DocuDescuento as money),1))
from DocumentoVenta d
inner join Cliente c
on c.ClienteId=d.ClienteId
inner join Compania co
on co.CompaniaId=d.CompaniaId
where d.TipoCodigo='07' and(Convert(char(10),d.DocuEmision,103) BETWEEN @fechainicio AND @fechafin)
order by d.DocuId desc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspListaSeries]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspListaSeries]
as
begin
select
'UsuarioId|CompaniaId|Compania|Usuario|Serie|EnviaBoleta|EnviarFactura|Estado¬100|85|100|180|100|100|100|105¬String|String|String|String|String|Boolean|Boolean|String¬'+
isnull((select STUFF ((select '¬'+ convert(varchar,u.UsuarioID)+'|'+convert(varchar,p.CompaniaId)+'|'+c.CompaniaRazonSocial+'|'+
(((SUBSTRING(p.PersonalNombres+' ',1,CHARINDEX(' ',p.PersonalNombres+' ')-1)))+' '+ ((SUBSTRING(p.PersonalApellidos+' ',1,CHARINDEX(' ',p.PersonalApellidos+' ')-1))))+'|'+
u.UsuarioSerie+'|'+convert(char(1),u.EnviaBoleta)+'|'+convert(char(1),u.EnviarFactura)+'|'+u.UsuarioEstado
from Usuarios u
inner join Personal p
on p.PersonalId=u.PersonalId
inner join Compania c
on c.CompaniaId=p.CompaniaId
where u.UsuarioEstado='ACTIVO'
order by p.PersonalNombres asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspOrdersGrabar]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[uspOrdersGrabar]
@ListaOrden varchar(Max),
@PKardex varchar(max)
As
Begin
	Declare @IdBloque numeric(38)
	Set  @IdBloque= -1
	Declare @pos int
	Set @pos = CharIndex('_',@ListaOrden,0)
	Declare @orden varchar(max)
	Declare @detalle varchar(max)
	Set @orden = SUBSTRING(@ListaOrden,1,@pos-1)
	Set @detalle = SUBSTRING(@ListaOrden,@pos+1,len(@ListaOrden)-@pos)
	Set @pos = CharIndex('|',@orden,0)
	declare @BloqueCaja numeric(38),
    @BloqueTotal decimal(18,2)
	Set @BloqueCaja=Convert(numeric(38),SUBSTRING(@orden,1,@pos-1))
	Set @BloqueTotal=Convert(decimal(18,2),SUBSTRING(@orden,@pos+1,len(@orden)-@pos))
	Begin Transaction
	Insert Into BLOQUE values(@BloqueCaja,GETDATE(),@BloqueTotal)
	Set @IdBloque= @@identity
	
	Declare Tabla Cursor For Select * From fnSplitString(@detalle,';')	
Open Tabla
		Declare @Columna varchar(max),
		@CajaId numeric(38),
		@NotaId numeric(38),
		@Monto decimal(18,2)
		Declare @pos1 int
		Declare @pos2 int
		Declare @pos3 int
	Fetch Next From Tabla INTO @Columna
	While @@FETCH_STATUS = 0
	Begin
		Set @pos1 = CharIndex('|',@Columna,0)
		Set @pos2 = CharIndex('|',@Columna,@pos1+1)
		Set @pos3 =Len(@Columna)+1
        Set @CajaId= Convert(numeric(38),SUBSTRING(@Columna,1,@pos1-1))
		Set @NotaId= Convert(numeric(38),SUBSTRING(@Columna,@pos1+1,@pos2-(@pos1+1)))
		Set @Monto= Convert(decimal(18,2),SUBSTRING(@Columna,@pos2+1,@pos3-@pos2-1))
		insert into DetalleBloque values(@IdBloque,@NotaId)
		insert into CajaDetalle values(@CajaId,GETDATE(),@NotaId,'INGRESO','','Pago Inmediato en Efectivo','SOLES',0,@Monto,@Monto,0)
		update NotaPedido 
        set NotaSaldo=0,NotaAcuenta=@Monto,NotaEstado='CANCELADO'
        where NotaId=@NotaId
		Fetch Next From Tabla INTO @Columna
	End
	Close Tabla;
	Deallocate Tabla;
	begin
	DECLARE @Kardex VARCHAR(MAX)
    Set @Kardex =@PKardex
	Declare TablaB Cursor For Select * From fnSplitString(@Kardex,';')	
Open TablaB
		Declare @ColumnaB varchar(max),
		@IdProducto numeric(20),
		@Documento varchar(150),
		@CantSalida decimal(18,2),
		@PrecioCosto decimal(18,4),
		@Usuario varchar(80)
		Declare @p1 int
		Declare @p2 int
		Declare @p3 int
		declare @p4 int
		declare @p5 int
		declare @IniciaStock decimal(18,2),@StockFinal decimal(18,2)
Fetch Next From TablaB INTO @ColumnaB
	While @@FETCH_STATUS = 0
	Begin
		Set @p1 = CharIndex('|',@ColumnaB,0)
		Set @p2 = CharIndex('|',@ColumnaB,@p1+1)
		Set @p3 = CharIndex('|',@ColumnaB,@p2+1)
		Set @p4 = CharIndex('|',@ColumnaB,@p3+1)
		Set @p5 =Len(@ColumnaB)+1
        Set @IdProducto=Convert(numeric(20),SUBSTRING(@ColumnaB,1,@p1-1))
		Set @Documento= Convert(varchar(150),SUBSTRING(@ColumnaB,@p1+1,@p2-(@p1+1)))
		Set @CantSalida= Convert(varchar(80),SUBSTRING(@ColumnaB,@p2+1,@p3-(@p2+1)))
		Set @PrecioCosto= Convert(varchar(80),SUBSTRING(@ColumnaB,@p3+1,@p4-(@p3+1)))
		Set @Usuario= Convert(varchar(80),SUBSTRING(@ColumnaB,@p4+1,@p5-@p4-1))
		set @IniciaStock=(select top 1 ProductoCantidad from Producto(nolock) where IdProducto=@IdProducto)
		set @StockFinal=@IniciaStock-@CantSalida
		insert into Kardex values(@IdProducto,GETDATE(),'Salida por Venta',@Documento,@IniciaStock,
		0,@CantSalida,@PrecioCosto,@StockFinal,'SALIDA',@Usuario)
		update producto 
	    set  ProductoCantidad =ProductoCantidad - @CantSalida
	    where IDProducto=@IdProducto
		Fetch Next From TablaB INTO @ColumnaB
	End
	Close TablaB;
	Deallocate TablaB;
	end
	Commit Transaction;
	Select 'true';
End
GO
/****** Object:  StoredProcedure [dbo].[uspReEnviarFactura]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspReEnviarFactura]
@Data varchar(max)
as
begin
Declare @p1 int,@p2 int,
        @p3 int
DECLARE @NotaId numeric(38),@CodigoSunat VARCHAR(80),
        @MensajeSunat varchar(max)
Set @p1 = CharIndex('|',@Data,0)
Set @p2 = CharIndex('|',@Data,@p1+1)
Set @p3 =Len(@Data)+1
Set @NotaId=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))
Set @CodigoSunat=convert(numeric(38),SUBSTRING(@Data,@p1+1,@p2-@p1-1))
Set @MensajeSunat=SUBSTRING(@Data,@p2+1,@p3-@p2-1)
update DocumentoVenta
set EstadoSunat='ENVIADO',CodigoSunat=@CodigoSunat,
MensajeSunat=@MensajeSunat
where NotaId=@NotaId and (TipoCodigo='01' and EstadoSunat='PENDIENTE')
update DetallePedido
set DetalleEstado='EMITIDO'
where NotaId=@NotaId
select 'true' 
end
GO
/****** Object:  StoredProcedure [dbo].[uspReEnviarNotaCredito]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspReEnviarNotaCredito]  
@Data varchar(max)  
as  
begin  
Declare @p1 int,@p2 int,  
        @p3 int  
DECLARE @DocuId numeric(38),@CodigoSunat VARCHAR(80),  
        @MensajeSunat varchar(max)  
Set @p1 = CharIndex('|',@Data,0)  
Set @p2 = CharIndex('|',@Data,@p1+1)  
Set @p3 =Len(@Data)+1  
Set @DocuId=convert(numeric(38),SUBSTRING(@Data,1,@p1-1))  
Set @CodigoSunat=convert(numeric(38),SUBSTRING(@Data,@p1+1,@p2-@p1-1))  
Set @MensajeSunat=SUBSTRING(@Data,@p2+1,@p3-@p2-1)  
update DocumentoVenta  
set EstadoSunat='ENVIADO',CodigoSunat=@CodigoSunat,MensajeSunat=@MensajeSunat  
where DocuId=@DocuId and (TipoCodigo='07' and EstadoSunat='PENDIENTE')  
select 'true'   
end
GO
/****** Object:  StoredProcedure [dbo].[uspReporteAnual]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspReporteAnual]
@CompaniaId int,
@ANNO int
AS
begin
SELECT
--isnull(b.NroMes,s.NroMes) as NroMes,
--isnull(b.Mes,S.Mes) as Mes, 
isnull(b.NroMes,isnull(S.NroMes,isnull(d.NroMes,isnull(x.NroMes,z.NroMes)))) as NroMes,
isnull(b.Mes,isnull(S.Mes,isnull(d.Mes,isnull(x.Mes,z.Mes)))) as Mes,
convert(varchar(50),cast((ISNULL(b.Monto,0))as money),1) as Ventas,
convert(varchar(50),cast((ISNULL(s.Monto,0)+ISNULL(d.Monto,0))-(ISNULL(x.Monto,0)+ISNULL(z.Monto,0))as money),1) as Compras,
convert(varchar(50),cast((ISNULL(b.Monto,0)-(ISNULL(s.Monto,0)+ISNULL(d.Monto,0))-(ISNULL(x.Monto,0)+ISNULL(z.Monto,0)))as money),1) as Ganancia
FROM(
select month(d.DocuEmision) as NroMes,Datename(MONTH,d.DocuEmision)as Mes,sum(d.DocuTotal)as Monto
from DocumentoVenta d with(nolock)
where (CompaniaId=@CompaniaId and year(d.DocuEmision)=@ANNO)and(D.DocuDocumento<>'PROFORMA V')
group by month(d.DocuEmision),Datename(MONTH,d.DocuEmision)) b
full join
(
    select month(c.CompraComputo) as NroMes,Datename(MONTH,c.CompraComputo)as Mes,SUM(c.CompraTotaL)as Monto
	from Compras c with(nolock)--FACTURAS EN SOLES
	where (c.CompaniaId=@CompaniaId AND year(c.CompraComputo)=@ANNO)and(c.TipoCodigo='01' and c.CompraMoneda='SOLES')
	group by month(c.CompraComputo),Datename(MONTH,c.CompraComputo)
)s on s.NroMes=b.NroMes
full join(
	select month(c.CompraComputo) as NroMes,Datename(MONTH,c.CompraComputo)as Mes,cast(sum(c.CompraTotal*c.CompraTipoSunat)as decimal(18,2)) as Monto
	from Compras c with(nolock)--FACTURAS EN DOLARES
	where (c.CompaniaId=@CompaniaId AND year(c.CompraComputo)=@ANNO) and (c.TipoCodigo='01' and c.CompraMoneda='DOLARES')
	group by month(c.CompraComputo),Datename(MONTH,c.CompraComputo)
)d on d.NroMes=b.NroMes
full join (
	select month(c.CompraComputo) as NroMes,Datename(MONTH,c.CompraComputo)as Mes,sum(c.CompraTotal) as Monto
	from Compras c with(nolock)--nota de credito en soles
	where (c.CompaniaId=@CompaniaId AND year(c.CompraComputo)=@ANNO) AND(c.TipoCodigo='07' and c.CompraMoneda='SOLES')
	group by month(c.CompraComputo),Datename(MONTH,c.CompraComputo)
)x on x.NroMes=b.NroMes
full join(
	select month(c.CompraComputo) as NroMes,Datename(MONTH,c.CompraComputo)as Mes,cast(sum(c.CompraTotal*c.CompraTipoSunat)as decimal(18,2)) as Monto
	from Compras c with(nolock)--credito EN DOLARES
	where c.CompaniaId=@CompaniaId AND year(c.CompraComputo)=@ANNO and (c.TipoCodigo='07' and c.CompraMoneda='DOLARES')
	group by month(c.CompraComputo),Datename(MONTH,c.CompraComputo)
)z on z.NroMes=b.NroMes
order by 1 asc
end
GO
/****** Object:  StoredProcedure [dbo].[uspReporteMozo]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uspReporteMozo]
@fechainicio date,
@fechafin date
as
begin
select t.NotaUsuario as Mozo,p.ProductoNombre as Descripcion,
CONVERT(VarChar(50), cast(SUM(d.DetalleCantidad) as money ), 1)as Cantidad,p.ProductoUM as UM,
CONVERT(VarChar(50), cast(SUM(d.DetalleImporte) as money ), 1) as Importe
from NotaPedido t
inner join DetallePedido d
on d.NotaId=t.NotaId
inner join Producto p
on p.IdProducto=d.IdProducto
where (t.NotaEstado='CANCELADO' and t.NotaConcepto='MERCADERIA') and(Convert(char(10),t.NotaFecha,103) BETWEEN @fechainicio AND @fechafin)
group by t.NotaUsuario,p.ProductoNombre,p.ProductoUM
end
GO
/****** Object:  StoredProcedure [dbo].[uspReporteMozoCaja]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uspReporteMozoCaja]
@CajaId numeric(38)
as
begin
select t.NotaUsuario as Mozo,p.ProductoNombre as Descripcion,
CONVERT(VarChar(50), cast(SUM(d.DetalleCantidad) as money ), 1)as Cantidad,p.ProductoUM as UM,
CONVERT(VarChar(50), cast(SUM(d.DetalleImporte) as money ), 1) as Importe
from NotaPedido t
inner join DetallePedido d
on d.NotaId=t.NotaId
inner join Producto p
on p.IdProducto=d.IdProducto
where CajaId=@CajaId and(t.NotaEstado='CANCELADO' and t.NotaConcepto='MERCADERIA')
group by t.NotaUsuario,p.ProductoNombre,p.ProductoUM
end
GO
/****** Object:  StoredProcedure [dbo].[uspResumenDetalle]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uspResumenDetalle] 
@fechainicio date,@fechafin date
as
begin
select 
'ID|Descripcion|Cantidad|UM|Importe¬90|400|110|100|115¬String|String|String|String|String¬'+
isnull((select STUFF((select '¬'+convert(varchar,d.IdProducto)+'|'+
d.DetalleDescripcion+'|'+
CONVERT(VarChar(50), cast(SUM(d.DetalleCantidad) as money ), 1)+'|'+d.DetalleUm+'|'+
CONVERT(VarChar(50), cast(SUM(d.DetalleImporte) as money ), 1)
from NotaPedido n
inner join DetallePedido d
on d.NotaId=n.NotaId
where n.NotaEstado='CANCELADO' and (Convert(char(10),n.NotaFecha,103) BETWEEN @fechainicio AND @fechafin)
group by d.IdProducto,d.DetalleDescripcion,d.DetalleUm
order by d.DetalleDescripcion asc
for xml path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspRetornaBoletaPorTicket]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspRetornaBoletaPorTicket]  
@ResumenId varchar(80)  
as  
begin  
declare @FechaEmision date  
declare @Dia int,@Mes int,@ANNO int  
set @FechaEmision=(select top 1 r.FechaReferencia from ResumenBoletas r where r.ResumenId=@ResumenId)  
set @Dia=DAY(@FechaEmision)  
set @Mes=MONTH(@FechaEmision)  
set @ANNO=YEAR(@FechaEmision)  
update ResumenBoletas  
set MensajeSunat='NO SE GENERO EL TICKET DE RESPUESTA DE SUNAT'  
where ResumenId=@ResumenId  
update DocumentoVenta  
set EstadoSunat='PENDIENTE'  
WHERE (DAY(DocuEmision)=@Dia AND MONTH(DocuEmision)=@Mes and YEAR(DocuEmision)=@ANNO) and TipoCodigo='03'  
select 'true'  
end
GO
/****** Object:  StoredProcedure [dbo].[uspRetornarBoletas]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspRetornarBoletas]  
@ResumenId numeric(38)  
as  
begin  
declare @FechaEmision date  
declare @Dia int,@Mes int,@ANNO int  
set @FechaEmision=(select top 1 r.FechaReferencia from ResumenBoletas r where r.ResumenId=@ResumenId)  
set @Dia=DAY(@FechaEmision)  
set @Mes=MONTH(@FechaEmision)  
set @ANNO=YEAR(@FechaEmision)  
update DocumentoVenta  
set EstadoSunat='PENDIENTE'  
WHERE (DAY(DocuEmision)=@Dia AND MONTH(DocuEmision)=@Mes and YEAR(DocuEmision)=@ANNO) and TipoCodigo='03'  
select 'true'  
end
GO
/****** Object:  StoredProcedure [dbo].[usptraerCaja]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usptraerCaja]
@UsuarioId int
as
begin
select
isnull((select stuff((select '¬'+
convert(varchar,c.CajaId)+'|'+
CONVERT(VarChar(50), cast(c.MontoIniSOl as money ), 1)+'|'+
c.CajaEncargado
from Caja c 
where c.CajaEstado='ACTIVO' and UsuarioId=@UsuarioId
order by c.CajaId desc
for xml path('')),1,1,'')),'0|0.00')
end
GO
/****** Object:  StoredProcedure [dbo].[uspTraerDV]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspTraerDV]          
@Valores varchar(max)          
as          
begin          
          
Declare @NotaId numeric(38),@DocuIdA numeric(38)          
Declare @a1 int,@a2 int          
Set @Valores= LTRIM(RTrim(@Valores))          
Set @a1 = CharIndex('|',@Valores,0)          
Set @a2= Len(@Valores)+1          
          
set @NotaId=SUBSTRING(@Valores,1,@a1-1)          
set @DocuIdA=SUBSTRING(@Valores,@a1+1,@a2-@a1-1)    
    
Declare @IGV decimal(18,2)    
    
set @IGV=(select top 1 c.IGV from Compania c)    
    
Declare @IgvD decimal(18,2),@IgvR decimal(18,2)    
    
set @IgvR=(@IGV/100)    
set @IgvD=@IgvR+1    
      
           
IF EXISTS(select top 1 NotaId             
from DocumentoVenta             
where NotaId=@NotaId and (TipoCodigo<>'07' and TipoCodigo <>'00'))            
begin            
Declare @lista varchar(max)            
Declare @Estado varchar(20),@Asociado varchar(40),@TipoCodigo char(2),@Serie char(4)            
Declare @DocuId numeric(38)            
declare @1 int,@2 int,@3 int,@4 int            
set @lista=(select top 1 d.DocuEstado+'|'+d.DocuAsociado+'|'+convert(char(2),d.TipoCodigo)+'|'+convert(varchar,d.DocuId)             
from DocumentoVenta d             
where NotaId=@NotaId and (TipoCodigo<>'07' and TipoCodigo <>'00')      
order by d.DocuId desc)            
Set @lista = LTRIM(RTrim(@lista))            
Set @1 = CharIndex('|',@lista,0)            
Set @2 = CharIndex('|',@lista,@1+1)            
Set @3 = CharIndex('|',@lista,@2+1)            
Set @4 = Len(@lista)+1            
set @Estado=SUBSTRING(@lista,1,@1-1)            
set @Asociado=SUBSTRING(@lista,@1+1,@2-@1-1)            
set @TipoCodigo=SUBSTRING(@lista,@2+1,@3-@2-1)            
set @DocuId=convert(numeric(38),SUBSTRING(@lista,@3+1,@4-@3-1))          
          
if(@TipoCodigo='01')set @Serie='FZ02'          
else if(@TipoCodigo='03')set @Serie='BZ02'          
--if(@Estado='ANULADO')select 'ANULADO'          
if(len(@Asociado)>0 and @DocuIdA=0)select 'CANJEADO'          
        
else            
begin            
Declare @Data varchar(max)            
Declare @NotaConcepto varchar(20)            
Declare @Entrega varchar(40)            
Declare @FormaPago varchar(40)            
Declare @NotaEstado varchar(40)            
declare @p1 int,@p2 int,@p3 int,@p4 int             
set @Data=(select top 1 NotaConcepto+'|'+n.NotaEntrega+'|'+n.NotaFormaPago+'|'+n.NotaEstado       
from NotaPedido n       
where n.NotaId=@NotaId)            
Set @Data = LTRIM(RTrim(@Data))            
Set @p1 = CharIndex('|',@Data,0)            
Set @p2 = CharIndex('|',@Data,@p1+1)            
Set @p3= CharIndex('|',@Data,@p2+1)            
Set @p4 = Len(@Data)+1            
set @NotaConcepto=SUBSTRING(@Data,1,@p1-1)            
set @Entrega=SUBSTRING(@Data,@p1+1,@p2-@p1-1)            
set @FormaPago=SUBSTRING(@Data,@p2+1,@p3-@p2-1)            
set @NotaEstado=SUBSTRING(@Data,@p3+1,@p4-@p3-1)            
select            
isnull((select STUFF((select top 1'¬'+d.DocuCondicion+'|'+d.EstadoSunat+'|'+d.DocuDocumento+'|'+            
d.DocuSerie+'-'+d.DocuNumero+'|'+convert(varchar,d.ClienteId)+'|'+            
c.ClienteRazon+'|'+c.ClienteRuc+'|'+c.ClienteDni+'|'+c.ClienteDireccion+'|'+            
(Convert(char(10),d.DocuEmision,103))+'  '+d.DocuUsuario+'|'+            
CONVERT(VarChar(50), cast(d.DocuTotal as money ), 1)+'|'+convert(varchar,d.CompaniaId)+'|'+            
(select dbo.genenerarNroFactura(@Serie,d.CompaniaId,'NOTA DE CREDITO'))+'|'+            
@Entrega+'|'+@FormaPago+'|'+@NotaEstado+'|'+convert(varchar,d.NotaId)+'|'+            
convert(varchar,d.DocuId)+'|'+@Serie+'|'+co.CompaniaRazonSocial+'|'+co.CompaniaComercial+'|'+            
co.CompaniaRUC+'|'+co.CompaniaUserSecun+'|'+co.ComapaniaPWD+'|'+co.CompaniaPFX+'|'+            
co.CompaniaClave+'|'+co.CompaniaEmail+'|'+co.CompaniaDireccion+'|'+co.CompaniaTelefono+'|'+            
co.CompaniaNomUBG+'|'+co.CompaniaCodigoUBG+'|'+co.CompaniaDistrito+'|'+co.CompaniaDirecSunat+'|'+            
CONVERT(VarChar(50), cast((n.NotaMovilidad+n.NotaAdicional) as money ),1)+'|'+            
CONVERT(VarChar(50), cast(d.DocuGravada as money ), 1)+'|'+            
CONVERT(VarChar(50), cast(d.DocuDescuento as money ), 1)+'|'+      
CONVERT(VarChar(50), cast(d.DocuSubTotal as money ), 1)+'|'+            
CONVERT(VarChar(50), cast(d.DocuIgv as money ), 1)            
from DocumentoVenta d            
inner join NotaPedido n            
on n.NotaId=d.NotaId            
inner join Cliente c            
on c.ClienteId=d.ClienteId            
inner join Compania co            
on co.CompaniaId=d.CompaniaId            
where d.NotaId=@NotaId and (TipoCodigo<>'07' and TipoCodigo <>'00')          
order by d.DocuId desc        
for xml path('')),1,1,'')),'~')+'['+            
'Cantidad|UM|Descripcion|Precio|Importe|DetalleId|IdProducto|valorUM|PrecioSunat|IGVPrecio|ImporteSunat|Codigo|Linea|CodSunat¬103|100|350|110|115|100|100|100|100|100|100|100|100|100¬String|String|String|String|String|String|String|String|String|String|Str
ing|String|String|String¬'+            
isnull((select STUFF((select '¬'+CONVERT(VarChar(50), cast(d.DetalleCantidad as money ), 1)+'|'+            
d.DetalleUM+'|'+p.ProductoNombre+'|'+            
CONVERT(VarChar(50), cast(d.DetallPrecio as money ), 1)+'|'+            
CONVERT(VarChar(50), cast(d.DetalleImporte as money ), 1)+'|'+            
convert(varchar,d.DetalleNotaId)+'|'+convert(varchar,d.IdProducto)+'|'+            
convert(varchar,d.ValorUM)+'|'+            
convert(varchar,convert(decimal(18,6),d.DetallPrecio/@IgvD))+'|'+            
convert(varchar,(convert(decimal(18,6),d.DetallPrecio/@IgvD)* d.DetalleCantidad)*@IgvR)+'|'+            
convert(varchar,convert(decimal(18,6),d.DetallPrecio/@IgvD)* d.DetalleCantidad) +'|'+            
p.ProductoCodigo+'|'+s.NombreSublinea+'|'+s.CodigoSUNAT            
from DetalleDocumento d            
inner join Producto p            
on p.IdProducto=d.IdProducto            
inner join Sublinea s            
on s.IdSubLinea=p.IdSubLinea            
where DocuId=@DocuId            
order by d.DetalleId asc            
for xml path('')),1,1,'')),'~')            
end            
end            
else            
begin            
select 'NO EXISTE'            
end            
end  
GO
/****** Object:  StoredProcedure [dbo].[uspTraerPFX]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspTraerPFX]    
@CompaniaId int    
as    
begin    
SELECT     
isnull((select STUFF ((select top 1'¬'+convert(varchar,c.CompaniaId)+'|'+c.CompaniaRazonSocial+'|'+    
c.CompaniaComercial+'|'+c.CompaniaRUC+'|'+c.CompaniaUserSecun+'|'+c.ComapaniaPWD+'|'+c.CompaniaPFX+'|'+c.CompaniaClave+'|'+    
convert(varchar,dbo.genenerarNroFactura('FA02',@CompaniaId,'FACTURA'))+'|'+c.CompaniaEmail+'|'+c.CompaniaDireccion+'|'+    
c.CompaniaTelefono+'|'+CompaniaNomUBG+'|'+CompaniaCodigoUBG+'|'+CompaniaDistrito+'|'+CompaniaDirecSunat    
FROM Compania c    
where c.CompaniaId=@CompaniaId    
for xml path('')),1,1,'')),'~')    
end
GO
/****** Object:  StoredProcedure [dbo].[usptraerSecuenciaResumen]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usptraerSecuenciaResumen]  
@CompaniaId varchar(20)  
as  
begin  
Declare @COUNT INT  
set @COUNT=(select COUNT(*) from ResumenBoletas)  
if(@COUNT=0)  
begin  
select '1'  
end  
else  
begin  
select top 1 convert(varchar,Secuencia+1)  
from ResumenBoletas where CompaniaId =@CompaniaId  
order by Secuencia desc  
end  
end
GO
/****** Object:  StoredProcedure [dbo].[uspUtilitario]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[uspUtilitario]
as
begin
select 
'TABLAS|TABLE['+
isnull((select STUFF((select '¬'+s.name+'|'+s.name
from sys.tables s
order by s.name asc
for XMl path('')),1,1,'')),'~')+'['+
'TYPO|COLUMN_NAME|DATA_TYPE|TAMANO¬0|220|150|115¬'+
isnull((select STUFF((select '¬'+ I.DATA_TYPE+'|'+I.COLUMN_NAME+'|'+I.DATA_TYPE+'|'+
       isnull(convert(varchar,case when CHARACTER_MAXIMUM_LENGTH is null then
       NUMERIC_PRECISION
       else CHARACTER_MAXIMUM_LENGTH end),'0')+','+isnull(convert(varchar,NUMERIC_SCALE),'0')+'|'+
       I.TABLE_NAME
FROM   INFORMATION_SCHEMA.COLUMNS I
order by TABLE_NAME asc
for XMl path('')),1,1,'')),'~')
end
GO
/****** Object:  StoredProcedure [dbo].[uspValidarApertura]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uspValidarApertura]  
as  
begin  
Declare @BoletaPen int  
Declare @ConsultaPen int   
Declare @AnuladosPen int  
Declare @ConsultaError int  
set @BoletaPen=(select top 1 count(DocuId) from DocumentoVenta  
where TipoCodigo='03'and((CompaniaId=1 and EstadoSunat='PENDIENTE')  
and DocuEmision<convert(date,GETDATE())))  
set @ConsultaPen=(select COUNT(ResumenId) from ResumenBoletas  
where CodigoSunat='')  
set @AnuladosPen=(select COUNT(d.DocuId) from DocumentoVenta d  
where d.TipoCodigo='03'and((d.CompaniaId=1 and DocuEstado='ANULADO' and d.EstadoSunat='ENVIADO')))  
set @ConsultaError=(select COUNT(ResumenId) from ResumenBoletas  
where CodigoSunat='env:Server' or CodigoSunat='env:Client')  
if(@BoletaPen>0)  
begin  
select 'BOLETA'  
END  
else if(@AnuladosPen>0)  
begin  
select 'ANULADOS'  
end  
else if(@ConsultaPen>0)  
begin  
select 'CONSULTA'  
end  
else if(@ConsultaError>0)  
begin  
select 'ERROR'  
end  
else  
begin  
select 'true'  
end  
end
GO
/****** Object:  StoredProcedure [dbo].[uspValidaUsuario]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uspValidaUsuario]    
@Data varchar(max)    
as    
begin    
Declare @p1 int,    
        @p2 int     
Declare @Usuario varchar(150),    
        @Clave varchar(150)      
Set @Data = LTRIM(RTrim(@Data))    
Set @p1 = CharIndex('|',@Data,0)    
Set @p2 = Len(@Data)+1    
Set @Usuario=SUBSTRING(@Data,1,@p1-1)    
Set @Clave=SUBSTRING(@Data,@p1+1,@p2-@p1-1)    
SELECT     
isnull((select STUFF ((select top 1 '¬'+convert(varchar,U.UsuarioID)+'|'+convert(varchar,p.PersonalId)+'|'+a.AreaNombre+'|'+    
(((SUBSTRING(p.PersonalNombres+' ',1,CHARINDEX(' ',p.PersonalNombres+' ')-1)))+' '+ ((SUBSTRING(p.PersonalApellidos+' ',1,CHARINDEX(' ',p.PersonalApellidos+' ')-1))))+'|'+    
convert(varchar,p.CompaniaId)+'|'+c.CompaniaRazonSocial+'|'+c.CompaniaRUC+'|'+u.UsuarioSerie+'|'+convert(varchar(1),u.EnviaBoleta)+'|'+    
convert(varchar(1),u.EnviarFactura)+'|'+c.CompaniaComercial+'|'+convert(varchar,c.ICBPER)  
+'|'+  
case when (CONVERT(date,GETDATE())>=(c.RenovacionFirma)) then  
'VENCIDO'  
else  
case when ((dateadd(DAY,-6,c.RenovacionFirma))<= CONVERT(date,GETDATE())) then  
'POR VENCER'  
else  
'PREMIUM' end end+'|'+  
(Convert(char(10),c.RenovacionFirma,103))+'|'+CONVERT(varchar,c.IGV)     
FROM Usuarios U    
inner join Personal p    
on p.PersonalId=U.PersonalId    
inner join Area a    
on a.AreaId=p.AreaId    
inner join Compania c    
on c.CompaniaId=p.CompaniaId    
where U.UsuarioAlias=@Usuario AND dbo.desincrectar(U.UsuarioClave)=@Clave and Usuarioestado ='ACTIVO'and p.PersonalEstado='ACTIVO'    
for xml path('')),1,1,'')),'~')    
end
GO
/****** Object:  StoredProcedure [dbo].[validarDatos]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[validarDatos]
@NotaId numeric(38)
as
begin
select a.NotaId,a.NotaEstado,a.Cantidad,isnull(b.Documento,0) as Emitidos,isnull(b.Acuenta,0)as Acuenta 
from 
(select n.NotaId,n.NotaEstado,
COUNT(IdDetalle) as Cantidad 
from DetalleGuia g 
inner join DetallePedido d 
on d.DetalleId=g.IdDetalle 
right join NotaPedido n
on n.NotaId=d.NotaId
where n.NotaId=@NotaId
group by n.NotaId,n.NotaEstado) a 
full join 
(select d.NotaId as NotaId,COUNT(d.NotaId) as Documento ,COUNT(l.DocuId) as Acuenta 
from DocumentoVenta d
left join DetaLiquidaVenta l
on l.DocuId=d.DocuId 
where d.NotaId=@NotaId
group by d.NotaId) b 
on a.NotaId=b.NotaId
end
GO
/****** Object:  StoredProcedure [dbo].[ventanaDeudas]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ventanaDeudas]
as
begin
select n.NotaId as ID,c.ClienteRazon,c.ClienteRuc,(IsNull(convert(varchar,n.NotaFecha,103),'')+' '+ IsNull(SUBSTRING(convert(varchar,n.NotaFecha,114),1,8),''))as DocuRegistro,
(Convert(char(10),n.NotaFechaPago,103)) as FechaPago,
case when n.NotaDocu='PROFORMA V' then
substring(n.NotaDocu,1,1)+'V '+convert(varchar,n.NotaId)
else substring(n.NotaDocu,1,1)+'V '+n.NotaSerie+'-'+n.NotaNumero end Documento
,CONVERT(VarChar(50),cast(n.NotaSaldo as money ), 1) as SaldoDoc,CONVERT(VarChar(50),cast(n.NotaTarjeta as money ), 1) as Tarjeta,
CONVERT(VarChar(50),cast(n.NotaPagar as money ), 1) as Total,n.NotaId
from NotaPedido n
inner join Cliente c
on  c.ClienteId=n.ClienteId
where (n.NotaCondicion='CREDITO' and (n.NotaEstado<>'CANCELADO' and n.NotaEstado<>'ANULADO'))and n.NotaSaldo > 0
order by n.NotaId desc
end
GO
/****** Object:  StoredProcedure [dbo].[ventanaFacturas]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[ventanaFacturas]@TipoCodigo varchar(40)
as
begin
select c.CompraId,p.ProveedorRazon,(Convert(char(10),c.CompraEmision,103)) as CompraEmision,substring(t.TipoDescripcion,1,1)+'C '+c.CompraSerie+'-'+c.CompraNumero as Numero,c.CompraMoneda,c.CompraTipoCambio,CONVERT(VarChar(50),cast(c.CompraSaldo as money ), 1) as SaldoDoc,CONVERT(VarChar(50),cast(c.CompraTotal as money ), 1) as Total,
t.TipoDescripcion
from Compras c
inner join Proveedor p
on  c.ProveedorId=p.ProveedorId
inner join TipoComprobante t
on t.TipoCodigo=c.TipoCodigo
where t.TipoCodigo=@TipoCodigo and c.CompraEstado='PENDIENTE DE PAGO'
order by c.CompraId desc
end
GO
/****** Object:  StoredProcedure [dbo].[ventanaLetras]    Script Date: 13/06/2026 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ventanaLetras]
as
begin
select d.DetalleId,l.LetraId,p.ProveedorRazon,(Convert(char(10),d.LetraVencimiento,103)) as Vencimiento,'LT '+d.LetraCanje as LetraCanje,
(Convert(char(10),l.LetraFechaGiro,103)) as FechaGiro,l.LetraMoneda,CONVERT(VarChar(50),cast(d.DetalleSaldo as money ), 1) as SaldoDoc,
CONVERT(VarChar(50),cast(d.DetalleMonto as money ), 1) as MontoDoc
from DetalleLetra d
inner join Letra l
on l.LetraId=d.LetraId
inner join Proveedor p
on p.ProveedorId=l.ProveedorId
where d.DetalleEstado<>'TOTALMENTE PAGADO'
order by d.LetraVencimiento asc
end
GO
USE [master]
GO
ALTER DATABASE [SAPECHI_T_A] SET  READ_WRITE 
GO
