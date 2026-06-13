# Comparacion de sapechiAntiguo.sql vs sapechi.sql

Generado automaticamente comparando `sapechiAntiguo.sql` como version antigua contra `sapechi.sql` como version actual.
Se ignoraron diferencias de nombre de base (`SAPECHIBAK` vs `SAPECHI`), fechas de script, rutas MDF/LDF y tamanos fisicos de archivo.

## Resumen

- Lineas: antiguo 12354, actual 12922.
- Objetos SQL detectados: antiguo 350, actual 383.
- Objetos agregados en actual: 33.
- Objetos eliminados en actual: 0.
- Objetos modificados: 0.
- Tablas agregadas: 19; tablas eliminadas: 0; tablas con columnas cambiadas: 0.
- Reglas/constraints `ALTER TABLE` agregadas: 26; eliminadas: 0.

## Objetos agregados

Por tipo: Index: 14, Table: 19.

- Index [EmailIndex] ON [dbo].[AspNetUsers]
- Index [IX_AspNetRoleClaims_RoleId] ON [dbo].[AspNetRoleClaims]
- Index [IX_AspNetUserClaims_UserId] ON [dbo].[AspNetUserClaims]
- Index [IX_AspNetUserLogins_UserId] ON [dbo].[AspNetUserLogins]
- Index [IX_AspNetUserRoles_RoleId] ON [dbo].[AspNetUserRoles]
- Index [IX_Images_ProductId] ON [dbo].[Images]
- Index [IX_OrderItems_OrderId] ON [dbo].[OrderItems]
- Index [IX_OrderItems_ProductId] ON [dbo].[OrderItems]
- Index [IX_Orders_OrderAddressId] ON [dbo].[Orders]
- Index [IX_Products_CategoryId] ON [dbo].[Products]
- Index [IX_Reviews_ProductId] ON [dbo].[Reviews]
- Index [IX_ShoppingCartItems_ShoppingCartId] ON [dbo].[ShoppingCartItems]
- Index [RoleNameIndex] ON [dbo].[AspNetRoles]
- Index [UserNameIndex] ON [dbo].[AspNetUsers]
- Table [dbo].[Addresses]
- Table [dbo].[AspNetRoleClaims]
- Table [dbo].[AspNetRoles]
- Table [dbo].[AspNetUserClaims]
- Table [dbo].[AspNetUserLogins]
- Table [dbo].[AspNetUserRoles]
- Table [dbo].[AspNetUserTokens]
- Table [dbo].[AspNetUsers]
- Table [dbo].[Categories]
- Table [dbo].[Countries]
- Table [dbo].[Images]
- Table [dbo].[OrderAddresses]
- Table [dbo].[OrderItems]
- Table [dbo].[Orders]
- Table [dbo].[Products]
- Table [dbo].[Reviews]
- Table [dbo].[ShoppingCartItems]
- Table [dbo].[ShoppingCarts]
- Table [dbo].[__EFMigrationsHistory]

## Objetos eliminados

- Ninguno.

## Objetos modificados

- Ninguno.

## Cambios de tablas y columnas

### Tablas agregadas

- `Addresses` con columnas: `Id`, `Direccion`, `Ciudad`, `Departamento`, `CodigoPostal`, `Username`, `Pais`, `CreatedDate`, `CreatedBy`, `LastModifiedDate`, `LastModifiedBy`
- `AspNetRoleClaims` con columnas: `Id`, `RoleId`, `ClaimType`, `ClaimValue`
- `AspNetRoles` con columnas: `Id`, `Name`, `NormalizedName`, `ConcurrencyStamp`
- `AspNetUserClaims` con columnas: `Id`, `UserId`, `ClaimType`, `ClaimValue`
- `AspNetUserLogins` con columnas: `LoginProvider`, `ProviderKey`, `ProviderDisplayName`, `UserId`
- `AspNetUserRoles` con columnas: `UserId`, `RoleId`
- `AspNetUserTokens` con columnas: `UserId`, `LoginProvider`, `Name`, `Value`
- `AspNetUsers` con columnas: `Id`, `Nombre`, `Apellido`, `Telefono`, `AvatarUrl`, `IsActive`, `UserName`, `NormalizedUserName`, `Email`, `NormalizedEmail`, `EmailConfirmed`, `PasswordHash`, `SecurityStamp`, `ConcurrencyStamp`, `PhoneNumber`, `PhoneNumberConfirmed`, `TwoFactorEnabled`, `LockoutEnd`, `LockoutEnabled`, `AccessFailedCount`
- `Categories` con columnas: `Id`, `Nombre`, `CreatedDate`, `CreatedBy`, `LastModifiedDate`, `LastModifiedBy`
- `Countries` con columnas: `Id`, `Name`, `Iso2`, `Iso3`, `CreatedDate`, `CreatedBy`, `LastModifiedDate`, `LastModifiedBy`
- `Images` con columnas: `Id`, `Url`, `ProductId`, `PublicCode`, `CreatedDate`, `CreatedBy`, `LastModifiedDate`, `LastModifiedBy`
- `OrderAddresses` con columnas: `Id`, `Direccion`, `Ciudad`, `Departamento`, `CodigoPostal`, `Username`, `Pais`, `CreatedDate`, `CreatedBy`, `LastModifiedDate`, `LastModifiedBy`
- `OrderItems` con columnas: `Id`, `ProductId`, `Precio`, `Cantidad`, `OrderId`, `ProductItemId`, `ProductNombre`, `ImagenUrl`, `CreatedDate`, `CreatedBy`, `LastModifiedDate`, `LastModifiedBy`
- `Orders` con columnas: `Id`, `CompradorNombre`, `CompradorUsername`, `OrderAddressId`, `Subtotal`, `Status`, `Total`, `Impuesto`, `PrecioEnvio`, `PaymentIntentId`, `ClientSecret`, `StripeApiKey`, `CreatedDate`, `CreatedBy`, `LastModifiedDate`, `LastModifiedBy`
- `Products` con columnas: `Id`, `Nombre`, `Precio`, `Descripcion`, `Rating`, `Vendedor`, `Stock`, `Status`, `CategoryId`, `CreatedDate`, `CreatedBy`, `LastModifiedDate`, `LastModifiedBy`
- `Reviews` con columnas: `Id`, `Nombre`, `Rating`, `Comentario`, `ProductId`, `CreatedDate`, `CreatedBy`, `LastModifiedDate`, `LastModifiedBy`
- `ShoppingCartItems` con columnas: `Id`, `Producto`, `Precio`, `Cantidad`, `Imagen`, `Categoria`, `ShoppingCartMasterId`, `ShoppingCartId`, `ProductId`, `Stock`, `CreatedDate`, `CreatedBy`, `LastModifiedDate`, `LastModifiedBy`
- `ShoppingCarts` con columnas: `Id`, `ShoppingCartMasterId`, `CreatedDate`, `CreatedBy`, `LastModifiedDate`, `LastModifiedBy`
- `__EFMigrationsHistory` con columnas: `MigrationId`, `ProductVersion`

- No se detectaron cambios de columnas en tablas existentes.

## Cambios en constraints / ALTER TABLE

### Agregados

```sql
ALTER TABLE [dbo].[AspNetRoleClaims] CHECK CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId]
```

```sql
ALTER TABLE [dbo].[AspNetRoleClaims] WITH CHECK ADD CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
```

```sql
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId]
```

```sql
ALTER TABLE [dbo].[AspNetUserClaims] WITH CHECK ADD CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
```

```sql
ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId]
```

```sql
ALTER TABLE [dbo].[AspNetUserLogins] WITH CHECK ADD CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
```

```sql
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId]
```

```sql
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId]
```

```sql
ALTER TABLE [dbo].[AspNetUserRoles] WITH CHECK ADD CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
```

```sql
ALTER TABLE [dbo].[AspNetUserRoles] WITH CHECK ADD CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
```

```sql
ALTER TABLE [dbo].[AspNetUserTokens] CHECK CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId]
```

```sql
ALTER TABLE [dbo].[AspNetUserTokens] WITH CHECK ADD CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
```

```sql
ALTER TABLE [dbo].[Images] CHECK CONSTRAINT [FK_Images_Products_ProductId]
```

```sql
ALTER TABLE [dbo].[Images] WITH CHECK ADD CONSTRAINT [FK_Images_Products_ProductId] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
ON DELETE CASCADE
```

```sql
ALTER TABLE [dbo].[OrderItems] CHECK CONSTRAINT [FK_OrderItems_Orders_OrderId]
```

```sql
ALTER TABLE [dbo].[OrderItems] CHECK CONSTRAINT [FK_OrderItems_Products_ProductId]
```

```sql
ALTER TABLE [dbo].[OrderItems] WITH CHECK ADD CONSTRAINT [FK_OrderItems_Orders_OrderId] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Orders] ([Id])
ON DELETE CASCADE
```

```sql
ALTER TABLE [dbo].[OrderItems] WITH CHECK ADD CONSTRAINT [FK_OrderItems_Products_ProductId] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
ON DELETE CASCADE
```

```sql
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_OrderAddresses_OrderAddressId]
```

```sql
ALTER TABLE [dbo].[Orders] WITH CHECK ADD CONSTRAINT [FK_Orders_OrderAddresses_OrderAddressId] FOREIGN KEY([OrderAddressId])
REFERENCES [dbo].[OrderAddresses] ([Id])
```

```sql
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_Categories_CategoryId]
```

```sql
ALTER TABLE [dbo].[Products] WITH CHECK ADD CONSTRAINT [FK_Products_Categories_CategoryId] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Categories] ([Id])
```

```sql
ALTER TABLE [dbo].[Reviews] CHECK CONSTRAINT [FK_Reviews_Products_ProductId]
```

```sql
ALTER TABLE [dbo].[Reviews] WITH CHECK ADD CONSTRAINT [FK_Reviews_Products_ProductId] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
ON DELETE CASCADE
```

```sql
ALTER TABLE [dbo].[ShoppingCartItems] CHECK CONSTRAINT [FK_ShoppingCartItems_ShoppingCarts_ShoppingCartId]
```

```sql
ALTER TABLE [dbo].[ShoppingCartItems] WITH CHECK ADD CONSTRAINT [FK_ShoppingCartItems_ShoppingCarts_ShoppingCartId] FOREIGN KEY([ShoppingCartId])
REFERENCES [dbo].[ShoppingCarts] ([Id])
ON DELETE CASCADE
```

## Fragmentos de diferencias por objeto modificado

- No hay objetos modificados despues de normalizar cabeceras/fechas.
## Diff global normalizado

Este bloque sirve como respaldo exacto. Puede estar recortado si el diff es muy largo.

```diff
--- sapechiAntiguo.sql
+++ sapechi.sql
@@
 return @NomMes
 end
 GO
+/****** Object: Table [dbo].[__EFMigrationsHistory] Script Date: <ignored>******/
+SET ANSI_NULLS ON
+GO
+SET QUOTED_IDENTIFIER ON
+GO
+CREATE TABLE [dbo].[__EFMigrationsHistory](
+[MigrationId] [nvarchar](150) NOT NULL,
+[ProductVersion] [nvarchar](32) NOT NULL,
+CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED
+(
+[MigrationId] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+) ON [PRIMARY]
+GO
+/****** Object: Table [dbo].[Addresses] Script Date: <ignored>******/
+SET ANSI_NULLS ON
+GO
+SET QUOTED_IDENTIFIER ON
+GO
+CREATE TABLE [dbo].[Addresses](
+[Id] [int] IDENTITY(1,1) NOT NULL,
+[Direccion] [nvarchar](max) NULL,
+[Ciudad] [nvarchar](max) NULL,
+[Departamento] [nvarchar](max) NULL,
+[CodigoPostal] [nvarchar](max) NULL,
+[Username] [nvarchar](max) NULL,
+[Pais] [nvarchar](max) NULL,
+[CreatedDate] [datetime2](7) NULL,
+[CreatedBy] [nvarchar](max) NULL,
+[LastModifiedDate] [datetime2](7) NULL,
+[LastModifiedBy] [nvarchar](max) NULL,
+CONSTRAINT [PK_Addresses] PRIMARY KEY CLUSTERED
+(
+[Id] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
+GO
 /****** Object: Table [dbo].[Almacen] Script Date: <ignored>******/
 SET ANSI_NULLS ON
 GO
@@
 )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
 ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
 GO
+/****** Object: Table [dbo].[AspNetRoleClaims] Script Date: <ignored>******/
+SET ANSI_NULLS ON
+GO
+SET QUOTED_IDENTIFIER ON
+GO
+CREATE TABLE [dbo].[AspNetRoleClaims](
+[Id] [int] IDENTITY(1,1) NOT NULL,
+[RoleId] [nvarchar](36) NOT NULL,
+[ClaimType] [nvarchar](max) NULL,
+[ClaimValue] [nvarchar](max) NULL,
+CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY CLUSTERED
+(
+[Id] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
+GO
+/****** Object: Table [dbo].[AspNetRoles] Script Date: <ignored>******/
+SET ANSI_NULLS ON
+GO
+SET QUOTED_IDENTIFIER ON
+GO
+CREATE TABLE [dbo].[AspNetRoles](
+[Id] [nvarchar](36) NOT NULL,
+[Name] [nvarchar](256) NULL,
+[NormalizedName] [nvarchar](90) NULL,
+[ConcurrencyStamp] [nvarchar](max) NULL,
+CONSTRAINT [PK_AspNetRoles] PRIMARY KEY CLUSTERED
+(
+[Id] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
+GO
+/****** Object: Table [dbo].[AspNetUserClaims] Script Date: <ignored>******/
+SET ANSI_NULLS ON
+GO
+SET QUOTED_IDENTIFIER ON
+GO
+CREATE TABLE [dbo].[AspNetUserClaims](
+[Id] [int] IDENTITY(1,1) NOT NULL,
+[UserId] [nvarchar](36) NOT NULL,
+[ClaimType] [nvarchar](max) NULL,
+[ClaimValue] [nvarchar](max) NULL,
+CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY CLUSTERED
+(
+[Id] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
+GO
+/****** Object: Table [dbo].[AspNetUserLogins] Script Date: <ignored>******/
+SET ANSI_NULLS ON
+GO
+SET QUOTED_IDENTIFIER ON
+GO
+CREATE TABLE [dbo].[AspNetUserLogins](
+[LoginProvider] [nvarchar](450) NOT NULL,
+[ProviderKey] [nvarchar](450) NOT NULL,
+[ProviderDisplayName] [nvarchar](max) NULL,
+[UserId] [nvarchar](36) NOT NULL,
+CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY CLUSTERED
+(
+[LoginProvider] ASC,
+[ProviderKey] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
+GO
+/****** Object: Table [dbo].[AspNetUserRoles] Script Date: <ignored>******/
+SET ANSI_NULLS ON
+GO
+SET QUOTED_IDENTIFIER ON
+GO
+CREATE TABLE [dbo].[AspNetUserRoles](
+[UserId] [nvarchar](36) NOT NULL,
+[RoleId] [nvarchar](36) NOT NULL,
+CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY CLUSTERED
+(
+[UserId] ASC,
+[RoleId] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+) ON [PRIMARY]
+GO
+/****** Object: Table [dbo].[AspNetUsers] Script Date: <ignored>******/
+SET ANSI_NULLS ON
+GO
+SET QUOTED_IDENTIFIER ON
+GO
+CREATE TABLE [dbo].[AspNetUsers](
+[Id] [nvarchar](36) NOT NULL,
+[Nombre] [nvarchar](max) NULL,
+[Apellido] [nvarchar](max) NULL,
+[Telefono] [nvarchar](max) NULL,
+[AvatarUrl] [nvarchar](max) NULL,
+[IsActive] [bit] NOT NULL,
+[UserName] [nvarchar](256) NULL,
+[NormalizedUserName] [nvarchar](90) NULL,
+[Email] [nvarchar](256) NULL,
+[NormalizedEmail] [nvarchar](256) NULL,
+[EmailConfirmed] [bit] NOT NULL,
+[PasswordHash] [nvarchar](max) NULL,
+[SecurityStamp] [nvarchar](max) NULL,
+[ConcurrencyStamp] [nvarchar](max) NULL,
+[PhoneNumber] [nvarchar](max) NULL,
+[PhoneNumberConfirmed] [bit] NOT NULL,
+[TwoFactorEnabled] [bit] NOT NULL,
+[LockoutEnd] [datetimeoffset](7) NULL,
+[LockoutEnabled] [bit] NOT NULL,
+[AccessFailedCount] [int] NOT NULL,
+CONSTRAINT [PK_AspNetUsers] PRIMARY KEY CLUSTERED
+(
+[Id] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
+GO
+/****** Object: Table [dbo].[AspNetUserTokens] Script Date: <ignored>******/
+SET ANSI_NULLS ON
+GO
+SET QUOTED_IDENTIFIER ON
+GO
+CREATE TABLE [dbo].[AspNetUserTokens](
+[UserId] [nvarchar](36) NOT NULL,
+[LoginProvider] [nvarchar](450) NOT NULL,
+[Name] [nvarchar](450) NOT NULL,
+[Value] [nvarchar](max) NULL,
+CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY CLUSTERED
+(
+[UserId] ASC,
+[LoginProvider] ASC,
+[Name] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
+GO
 /****** Object: Table [dbo].[BLOQUE] Script Date: <ignored>******/
 SET ANSI_NULLS ON
 GO
@@
 )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
 ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
 GO
+/****** Object: Table [dbo].[Categories] Script Date: <ignored>******/
+SET ANSI_NULLS ON
+GO
+SET QUOTED_IDENTIFIER ON
+GO
+CREATE TABLE [dbo].[Categories](
+[Id] [int] IDENTITY(1,1) NOT NULL,
+[Nombre] [nvarchar](100) NULL,
+[CreatedDate] [datetime2](7) NULL,
+[CreatedBy] [nvarchar](max) NULL,
+[LastModifiedDate] [datetime2](7) NULL,
+[LastModifiedBy] [nvarchar](max) NULL,
+CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED
+(
+[Id] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
+GO
 /****** Object: Table [dbo].[Cliente] Script Date: <ignored>******/
 SET ANSI_NULLS ON
 GO
@@
 )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
 ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
 GO
+/****** Object: Table [dbo].[Countries] Script Date: <ignored>******/
+SET ANSI_NULLS ON
+GO
+SET QUOTED_IDENTIFIER ON
+GO
+CREATE TABLE [dbo].[Countries](
+[Id] [int] IDENTITY(1,1) NOT NULL,
+[Name] [nvarchar](max) NULL,
+[Iso2] [nvarchar](max) NULL,
+[Iso3] [nvarchar](max) NULL,
+[CreatedDate] [datetime2](7) NULL,
+[CreatedBy] [nvarchar](max) NULL,
+[LastModifiedDate] [datetime2](7) NULL,
+[LastModifiedBy] [nvarchar](max) NULL,
+CONSTRAINT [PK_Countries] PRIMARY KEY CLUSTERED
+(
+[Id] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
+GO
 /****** Object: Table [dbo].[CuentaProveedor] Script Date: <ignored>******/
 SET ANSI_NULLS ON
 GO
@@
 )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
 ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
 GO
+/****** Object: Table [dbo].[Images] Script Date: <ignored>******/
+SET ANSI_NULLS ON
+GO
+SET QUOTED_IDENTIFIER ON
+GO
+CREATE TABLE [dbo].[Images](
+[Id] [int] IDENTITY(1,1) NOT NULL,
+[Url] [nvarchar](4000) NULL,
+[ProductId] [int] NOT NULL,
+[PublicCode] [nvarchar](max) NULL,
+[CreatedDate] [datetime2](7) NULL,
+[CreatedBy] [nvarchar](max) NULL,
+[LastModifiedDate] [datetime2](7) NULL,
+[LastModifiedBy] [nvarchar](max) NULL,
+CONSTRAINT [PK_Images] PRIMARY KEY CLUSTERED
+(
+[Id] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
+GO
 /****** Object: Table [dbo].[Kardex] Script Date: <ignored>******/
 SET ANSI_NULLS ON
 GO
@@
 )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
 ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
 GO
+/****** Object: Table [dbo].[OrderAddresses] Script Date: <ignored>******/
+SET ANSI_NULLS ON
+GO
+SET QUOTED_IDENTIFIER ON
+GO
+CREATE TABLE [dbo].[OrderAddresses](
+[Id] [int] IDENTITY(1,1) NOT NULL,
+[Direccion] [nvarchar](max) NULL,
+[Ciudad] [nvarchar](max) NULL,
+[Departamento] [nvarchar](max) NULL,
+[CodigoPostal] [nvarchar](max) NULL,
+[Username] [nvarchar](max) NULL,
+[Pais] [nvarchar](max) NULL,
+[CreatedDate] [datetime2](7) NULL,
+[CreatedBy] [nvarchar](max) NULL,
+[LastModifiedDate] [datetime2](7) NULL,
+[LastModifiedBy] [nvarchar](max) NULL,
+CONSTRAINT [PK_OrderAddresses] PRIMARY KEY CLUSTERED
+(
+[Id] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
+GO
+/****** Object: Table [dbo].[OrderItems] Script Date: <ignored>******/
+SET ANSI_NULLS ON
+GO
+SET QUOTED_IDENTIFIER ON
+GO
+CREATE TABLE [dbo].[OrderItems](
+[Id] [int] IDENTITY(1,1) NOT NULL,
+[ProductId] [int] NOT NULL,
+[Precio] [decimal](10, 2) NOT NULL,
+[Cantidad] [int] NOT NULL,
+[OrderId] [int] NOT NULL,
+[ProductItemId] [int] NOT NULL,
+[ProductNombre] [nvarchar](max) NULL,
+[ImagenUrl] [nvarchar](max) NULL,
+[CreatedDate] [datetime2](7) NULL,
+[CreatedBy] [nvarchar](max) NULL,
+[LastModifiedDate] [datetime2](7) NULL,
+[LastModifiedBy] [nvarchar](max) NULL,
+CONSTRAINT [PK_OrderItems] PRIMARY KEY CLUSTERED
+(
+[Id] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
+GO
+/****** Object: Table [dbo].[Orders] Script Date: <ignored>******/
+SET ANSI_NULLS ON
+GO
+SET QUOTED_IDENTIFIER ON
+GO
+CREATE TABLE [dbo].[Orders](
+[Id] [int] IDENTITY(1,1) NOT NULL,
+[CompradorNombre] [nvarchar](max) NULL,
+[CompradorUsername] [nvarchar](max) NULL,
+[OrderAddressId] [int] NULL,
+[Subtotal] [decimal](10, 2) NOT NULL,
+[Status] [int] NOT NULL,
+[Total] [decimal](10, 2) NOT NULL,
+[Impuesto] [decimal](10, 2) NOT NULL,
+[PrecioEnvio] [decimal](10, 2) NOT NULL,
+[PaymentIntentId] [nvarchar](max) NULL,
+[ClientSecret] [nvarchar](max) NULL,
+[StripeApiKey] [nvarchar](max) NULL,
+[CreatedDate] [datetime2](7) NULL,
+[CreatedBy] [nvarchar](max) NULL,
+[LastModifiedDate] [datetime2](7) NULL,
+[LastModifiedBy] [nvarchar](max) NULL,
+CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED
+(
+[Id] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
+GO
 /****** Object: Table [dbo].[Personal] Script Date: <ignored>******/
 SET ANSI_NULLS ON
 GO
@@
 )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
 ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
 GO
+/****** Object: Table [dbo].[Products] Script Date: <ignored>******/
+SET ANSI_NULLS ON
+GO
+SET QUOTED_IDENTIFIER ON
+GO
+CREATE TABLE [dbo].[Products](
+[Id] [int] IDENTITY(1,1) NOT NULL,
+[Nombre] [nvarchar](100) NULL,
+[Precio] [decimal](10, 2) NOT NULL,
+[Descripcion] [nvarchar](4000) NULL,
+[Rating] [int] NOT NULL,
+[Vendedor] [nvarchar](100) NULL,
+[Stock] [int] NOT NULL,
+[Status] [int] NOT NULL,
+[CategoryId] [int] NOT NULL,
+[CreatedDate] [datetime2](7) NULL,
+[CreatedBy] [nvarchar](max) NULL,
+[LastModifiedDate] [datetime2](7) NULL,
+[LastModifiedBy] [nvarchar](max) NULL,
+CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED
+(
+[Id] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
+GO
 /****** Object: Table [dbo].[Proveedor] Script Date: <ignored>******/
 SET ANSI_NULLS ON
 GO
@@
 )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
 ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
 GO
+/****** Object: Table [dbo].[Reviews] Script Date: <ignored>******/
+SET ANSI_NULLS ON
+GO
+SET QUOTED_IDENTIFIER ON
+GO
+CREATE TABLE [dbo].[Reviews](
+[Id] [int] IDENTITY(1,1) NOT NULL,
+[Nombre] [nvarchar](100) NULL,
+[Rating] [int] NOT NULL,
+[Comentario] [nvarchar](4000) NULL,
+[ProductId] [int] NOT NULL,
+[CreatedDate] [datetime2](7) NULL,
+[CreatedBy] [nvarchar](max) NULL,
+[LastModifiedDate] [datetime2](7) NULL,
+[LastModifiedBy] [nvarchar](max) NULL,
+CONSTRAINT [PK_Reviews] PRIMARY KEY CLUSTERED
+(
+[Id] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
+GO
+/****** Object: Table [dbo].[ShoppingCartItems] Script Date: <ignored>******/
+SET ANSI_NULLS ON
+GO
+SET QUOTED_IDENTIFIER ON
+GO
+CREATE TABLE [dbo].[ShoppingCartItems](
+[Id] [int] IDENTITY(1,1) NOT NULL,
+[Producto] [nvarchar](max) NULL,
+[Precio] [decimal](10, 2) NOT NULL,
+[Cantidad] [int] NOT NULL,
+[Imagen] [nvarchar](max) NULL,
+[Categoria] [nvarchar](max) NULL,
+[ShoppingCartMasterId] [uniqueidentifier] NULL,
+[ShoppingCartId] [int] NOT NULL,
+[ProductId] [int] NOT NULL,
+[Stock] [int] NOT NULL,
+[CreatedDate] [datetime2](7) NULL,
+[CreatedBy] [nvarchar](max) NULL,
+[LastModifiedDate] [datetime2](7) NULL,
+[LastModifiedBy] [nvarchar](max) NULL,
+CONSTRAINT [PK_ShoppingCartItems] PRIMARY KEY CLUSTERED
+(
+[Id] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
+GO
+/****** Object: Table [dbo].[ShoppingCarts] Script Date: <ignored>******/
+SET ANSI_NULLS ON
+GO
+SET QUOTED_IDENTIFIER ON
+GO
+CREATE TABLE [dbo].[ShoppingCarts](
+[Id] [int] IDENTITY(1,1) NOT NULL,
+[ShoppingCartMasterId] [uniqueidentifier] NULL,
+[CreatedDate] [datetime2](7) NULL,
+[CreatedBy] [nvarchar](max) NULL,
+[LastModifiedDate] [datetime2](7) NULL,
+[LastModifiedBy] [nvarchar](max) NULL,
+CONSTRAINT [PK_ShoppingCarts] PRIMARY KEY CLUSTERED
+(
+[Id] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
+GO
 /****** Object: Table [dbo].[Sublinea] Script Date: <ignored>******/
 SET ANSI_NULLS ON
 GO
@@
 )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
 ) ON [PRIMARY]
 GO
+SET ANSI_PADDING ON
+GO
+/****** Object: Index [IX_AspNetRoleClaims_RoleId] Script Date: <ignored>******/
+CREATE NONCLUSTERED INDEX [IX_AspNetRoleClaims_RoleId] ON [dbo].[AspNetRoleClaims]
+(
+[RoleId] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+GO
+SET ANSI_PADDING ON
+GO
+/****** Object: Index [RoleNameIndex] Script Date: <ignored>******/
+CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex] ON [dbo].[AspNetRoles]
+(
+[NormalizedName] ASC
+)
+WHERE ([NormalizedName] IS NOT NULL)
+WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+GO
+SET ANSI_PADDING ON
+GO
+/****** Object: Index [IX_AspNetUserClaims_UserId] Script Date: <ignored>******/
+CREATE NONCLUSTERED INDEX [IX_AspNetUserClaims_UserId] ON [dbo].[AspNetUserClaims]
+(
+[UserId] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+GO
+SET ANSI_PADDING ON
+GO
+/****** Object: Index [IX_AspNetUserLogins_UserId] Script Date: <ignored>******/
+CREATE NONCLUSTERED INDEX [IX_AspNetUserLogins_UserId] ON [dbo].[AspNetUserLogins]
+(
+[UserId] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+GO
+SET ANSI_PADDING ON
+GO
+/****** Object: Index [IX_AspNetUserRoles_RoleId] Script Date: <ignored>******/
+CREATE NONCLUSTERED INDEX [IX_AspNetUserRoles_RoleId] ON [dbo].[AspNetUserRoles]
+(
+[RoleId] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+GO
+SET ANSI_PADDING ON
+GO
+/****** Object: Index [EmailIndex] Script Date: <ignored>******/
+CREATE NONCLUSTERED INDEX [EmailIndex] ON [dbo].[AspNetUsers]
+(
+[NormalizedEmail] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+GO
+SET ANSI_PADDING ON
+GO
+/****** Object: Index [UserNameIndex] Script Date: <ignored>******/
+CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex] ON [dbo].[AspNetUsers]
+(
+[NormalizedUserName] ASC
+)
+WHERE ([NormalizedUserName] IS NOT NULL)
+WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+GO
+/****** Object: Index [IX_Images_ProductId] Script Date: <ignored>******/
+CREATE NONCLUSTERED INDEX [IX_Images_ProductId] ON [dbo].[Images]
+(
+[ProductId] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+GO
+/****** Object: Index [IX_OrderItems_OrderId] Script Date: <ignored>******/
+CREATE NONCLUSTERED INDEX [IX_OrderItems_OrderId] ON [dbo].[OrderItems]
+(
+[OrderId] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+GO
+/****** Object: Index [IX_OrderItems_ProductId] Script Date: <ignored>******/
+CREATE NONCLUSTERED INDEX [IX_OrderItems_ProductId] ON [dbo].[OrderItems]
+(
+[ProductId] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+GO
+/****** Object: Index [IX_Orders_OrderAddressId] Script Date: <ignored>******/
+CREATE NONCLUSTERED INDEX [IX_Orders_OrderAddressId] ON [dbo].[Orders]
+(
+[OrderAddressId] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+GO
+/****** Object: Index [IX_Products_CategoryId] Script Date: <ignored>******/
+CREATE NONCLUSTERED INDEX [IX_Products_CategoryId] ON [dbo].[Products]
+(
+[CategoryId] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+GO
+/****** Object: Index [IX_Reviews_ProductId] Script Date: <ignored>******/
+CREATE NONCLUSTERED INDEX [IX_Reviews_ProductId] ON [dbo].[Reviews]
+(
+[ProductId] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+GO
+/****** Object: Index [IX_ShoppingCartItems_ShoppingCartId] Script Date: <ignored>******/
+CREATE NONCLUSTERED INDEX [IX_ShoppingCartItems_ShoppingCartId] ON [dbo].[ShoppingCartItems]
+(
+[ShoppingCartId] ASC
+)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
+GO
 ALTER TABLE [dbo].[Asistencia] WITH CHECK ADD FOREIGN KEY([PersonalId])
 REFERENCES [dbo].[Personal] ([PersonalId])
 GO
+ALTER TABLE [dbo].[AspNetRoleClaims] WITH CHECK ADD CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
+REFERENCES [dbo].[AspNetRoles] ([Id])
+ON DELETE CASCADE
+GO
+ALTER TABLE [dbo].[AspNetRoleClaims] CHECK CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId]
+GO
+ALTER TABLE [dbo].[AspNetUserClaims] WITH CHECK ADD CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY([UserId])
+REFERENCES [dbo].[AspNetUsers] ([Id])
+ON DELETE CASCADE
+GO
+ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId]
+GO
+ALTER TABLE [dbo].[AspNetUserLogins] WITH CHECK ADD CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY([UserId])
+REFERENCES [dbo].[AspNetUsers] ([Id])
+ON DELETE CASCADE
+GO
+ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId]
+GO
+ALTER TABLE [dbo].[AspNetUserRoles] WITH CHECK ADD CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
+REFERENCES [dbo].[AspNetRoles] ([Id])
+ON DELETE CASCADE
+GO
+ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId]
+GO
+ALTER TABLE [dbo].[AspNetUserRoles] WITH CHECK ADD CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY([UserId])
+REFERENCES [dbo].[AspNetUsers] ([Id])
+ON DELETE CASCADE
+GO
+ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId]
+GO
+ALTER TABLE [dbo].[AspNetUserTokens] WITH CHECK ADD CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY([UserId])
+REFERENCES [dbo].[AspNetUsers] ([Id])
+ON DELETE CASCADE
+GO
+ALTER TABLE [dbo].[AspNetUserTokens] CHECK CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId]
+GO
 ALTER TABLE [dbo].[CajaDetalle] WITH CHECK ADD FOREIGN KEY([CajaId])
 REFERENCES [dbo].[Caja] ([CajaId])
 GO
@@
 ALTER TABLE [dbo].[GuiaCanje] WITH CHECK ADD FOREIGN KEY([CompraId])
 REFERENCES [dbo].[Compras] ([CompraId])
 GO
+ALTER TABLE [dbo].[Images] WITH CHECK ADD CONSTRAINT [FK_Images_Products_ProductId] FOREIGN KEY([ProductId])
+REFERENCES [dbo].[Products] ([Id])
+ON DELETE CASCADE
+GO
+ALTER TABLE [dbo].[Images] CHECK CONSTRAINT [FK_Images_Products_ProductId]
+GO
 ALTER TABLE [dbo].[Letra] WITH CHECK ADD FOREIGN KEY([ProveedorId])
 REFERENCES [dbo].[Proveedor] ([ProveedorId])
 GO
@@
 ALTER TABLE [dbo].[NotaPedido] WITH CHECK ADD FOREIGN KEY([CompaniaId])
 REFERENCES [dbo].[Compania] ([CompaniaId])
 GO
+ALTER TABLE [dbo].[OrderItems] WITH CHECK ADD CONSTRAINT [FK_OrderItems_Orders_OrderId] FOREIGN KEY([OrderId])
+REFERENCES [dbo].[Orders] ([Id])
+ON DELETE CASCADE
+GO
+ALTER TABLE [dbo].[OrderItems] CHECK CONSTRAINT [FK_OrderItems_Orders_OrderId]
+GO
+ALTER TABLE [dbo].[OrderItems] WITH CHECK ADD CONSTRAINT [FK_OrderItems_Products_ProductId] FOREIGN KEY([ProductId])
+REFERENCES [dbo].[Products] ([Id])
+ON DELETE CASCADE
+GO
+ALTER TABLE [dbo].[OrderItems] CHECK CONSTRAINT [FK_OrderItems_Products_ProductId]
+GO
+ALTER TABLE [dbo].[Orders] WITH CHECK ADD CONSTRAINT [FK_Orders_OrderAddresses_OrderAddressId] FOREIGN KEY([OrderAddressId])
+REFERENCES [dbo].[OrderAddresses] ([Id])
+GO
+ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_OrderAddresses_OrderAddressId]
+GO
 ALTER TABLE [dbo].[Personal] WITH CHECK ADD FOREIGN KEY([AreaId])
 REFERENCES [dbo].[Area] ([AreaId])
 GO
@@
 ALTER TABLE [dbo].[Producto] WITH CHECK ADD FOREIGN KEY([IdSubLinea])
 REFERENCES [dbo].[Sublinea] ([IdSubLinea])
 GO
+ALTER TABLE [dbo].[Products] WITH CHECK ADD CONSTRAINT [FK_Products_Categories_CategoryId] FOREIGN KEY([CategoryId])
+REFERENCES [dbo].[Categories] ([Id])
+GO
+ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_Categories_CategoryId]
+GO
 ALTER TABLE [dbo].[RentaMensual] WITH CHECK ADD FOREIGN KEY([CompaniaId])
 REFERENCES [dbo].[Compania] ([CompaniaId])
 GO
+ALTER TABLE [dbo].[Reviews] WITH CHECK ADD CONSTRAINT [FK_Reviews_Products_ProductId] FOREIGN KEY([ProductId])
+REFERENCES [dbo].[Products] ([Id])
+ON DELETE CASCADE
+GO
+ALTER TABLE [dbo].[Reviews] CHECK CONSTRAINT [FK_Reviews_Products_ProductId]
+GO
+ALTER TABLE [dbo].[ShoppingCartItems] WITH CHECK ADD CONSTRAINT [FK_ShoppingCartItems_ShoppingCarts_ShoppingCartId] FOREIGN KEY([ShoppingCartId])
+REFERENCES [dbo].[ShoppingCarts] ([Id])
+ON DELETE CASCADE
+GO
+ALTER TABLE [dbo].[ShoppingCartItems] CHECK CONSTRAINT [FK_ShoppingCartItems_ShoppingCarts_ShoppingCartId]
+GO
 ALTER TABLE [dbo].[Sublinea] WITH CHECK ADD FOREIGN KEY([IdLinea])
 REFERENCES [dbo].[Linea] ([IdLinea])
 GO
```
