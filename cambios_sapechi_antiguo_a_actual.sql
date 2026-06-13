
USE [SAPECHI]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[dbo].[__EFMigrationsHistory]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[__EFMigrationsHistory](
    	[MigrationId] [nvarchar](150) NOT NULL,
    	[ProductVersion] [nvarchar](32) NOT NULL,
     CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
    (
    	[MigrationId] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]
END
GO

-- Table [dbo].[Addresses]
/****** Object:  Table [dbo].[Addresses]    Script Date: <ignored>******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[dbo].[Addresses]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Addresses](
    	[Id] [int] IDENTITY(1,1) NOT NULL,
    	[Direccion] [nvarchar](max) NULL,
    	[Ciudad] [nvarchar](max) NULL,
    	[Departamento] [nvarchar](max) NULL,
    	[CodigoPostal] [nvarchar](max) NULL,
    	[Username] [nvarchar](max) NULL,
    	[Pais] [nvarchar](max) NULL,
    	[CreatedDate] [datetime2](7) NULL,
    	[CreatedBy] [nvarchar](max) NULL,
    	[LastModifiedDate] [datetime2](7) NULL,
    	[LastModifiedBy] [nvarchar](max) NULL,
     CONSTRAINT [PK_Addresses] PRIMARY KEY CLUSTERED 
    (
    	[Id] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

-- Table [dbo].[AspNetRoleClaims]
/****** Object:  Table [dbo].[AspNetRoleClaims]    Script Date: <ignored>******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[dbo].[AspNetRoleClaims]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[AspNetRoleClaims](
    	[Id] [int] IDENTITY(1,1) NOT NULL,
    	[RoleId] [nvarchar](36) NOT NULL,
    	[ClaimType] [nvarchar](max) NULL,
    	[ClaimValue] [nvarchar](max) NULL,
     CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY CLUSTERED 
    (
    	[Id] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

-- Table [dbo].[AspNetRoles]
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: <ignored>******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[dbo].[AspNetRoles]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[AspNetRoles](
    	[Id] [nvarchar](36) NOT NULL,
    	[Name] [nvarchar](256) NULL,
    	[NormalizedName] [nvarchar](90) NULL,
    	[ConcurrencyStamp] [nvarchar](max) NULL,
     CONSTRAINT [PK_AspNetRoles] PRIMARY KEY CLUSTERED 
    (
    	[Id] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

-- Table [dbo].[AspNetUserClaims]
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: <ignored>******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[dbo].[AspNetUserClaims]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[AspNetUserClaims](
    	[Id] [int] IDENTITY(1,1) NOT NULL,
    	[UserId] [nvarchar](36) NOT NULL,
    	[ClaimType] [nvarchar](max) NULL,
    	[ClaimValue] [nvarchar](max) NULL,
     CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY CLUSTERED 
    (
    	[Id] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

-- Table [dbo].[AspNetUserLogins]
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: <ignored>******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[dbo].[AspNetUserLogins]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[AspNetUserLogins](
    	[LoginProvider] [nvarchar](450) NOT NULL,
    	[ProviderKey] [nvarchar](450) NOT NULL,
    	[ProviderDisplayName] [nvarchar](max) NULL,
    	[UserId] [nvarchar](36) NOT NULL,
     CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY CLUSTERED 
    (
    	[LoginProvider] ASC,
    	[ProviderKey] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

-- Table [dbo].[AspNetUserRoles]
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: <ignored>******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[dbo].[AspNetUserRoles]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[AspNetUserRoles](
    	[UserId] [nvarchar](36) NOT NULL,
    	[RoleId] [nvarchar](36) NOT NULL,
     CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY CLUSTERED 
    (
    	[UserId] ASC,
    	[RoleId] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]
END
GO

-- Table [dbo].[AspNetUsers]
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: <ignored>******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[dbo].[AspNetUsers]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[AspNetUsers](
    	[Id] [nvarchar](36) NOT NULL,
    	[Nombre] [nvarchar](max) NULL,
    	[Apellido] [nvarchar](max) NULL,
    	[Telefono] [nvarchar](max) NULL,
    	[AvatarUrl] [nvarchar](max) NULL,
    	[IsActive] [bit] NOT NULL,
    	[UserName] [nvarchar](256) NULL,
    	[NormalizedUserName] [nvarchar](90) NULL,
    	[Email] [nvarchar](256) NULL,
    	[NormalizedEmail] [nvarchar](256) NULL,
    	[EmailConfirmed] [bit] NOT NULL,
    	[PasswordHash] [nvarchar](max) NULL,
    	[SecurityStamp] [nvarchar](max) NULL,
    	[ConcurrencyStamp] [nvarchar](max) NULL,
    	[PhoneNumber] [nvarchar](max) NULL,
    	[PhoneNumberConfirmed] [bit] NOT NULL,
    	[TwoFactorEnabled] [bit] NOT NULL,
    	[LockoutEnd] [datetimeoffset](7) NULL,
    	[LockoutEnabled] [bit] NOT NULL,
    	[AccessFailedCount] [int] NOT NULL,
     CONSTRAINT [PK_AspNetUsers] PRIMARY KEY CLUSTERED 
    (
    	[Id] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

-- Table [dbo].[AspNetUserTokens]
/****** Object:  Table [dbo].[AspNetUserTokens]    Script Date: <ignored>******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[dbo].[AspNetUserTokens]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[AspNetUserTokens](
    	[UserId] [nvarchar](36) NOT NULL,
    	[LoginProvider] [nvarchar](450) NOT NULL,
    	[Name] [nvarchar](450) NOT NULL,
    	[Value] [nvarchar](max) NULL,
     CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY CLUSTERED 
    (
    	[UserId] ASC,
    	[LoginProvider] ASC,
    	[Name] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

-- Table [dbo].[Categories]
/****** Object:  Table [dbo].[Categories]    Script Date: <ignored>******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[dbo].[Categories]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Categories](
    	[Id] [int] IDENTITY(1,1) NOT NULL,
    	[Nombre] [nvarchar](100) NULL,
    	[CreatedDate] [datetime2](7) NULL,
    	[CreatedBy] [nvarchar](max) NULL,
    	[LastModifiedDate] [datetime2](7) NULL,
    	[LastModifiedBy] [nvarchar](max) NULL,
     CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
    (
    	[Id] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

-- Table [dbo].[Countries]
/****** Object:  Table [dbo].[Countries]    Script Date: <ignored>******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[dbo].[Countries]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Countries](
    	[Id] [int] IDENTITY(1,1) NOT NULL,
    	[Name] [nvarchar](max) NULL,
    	[Iso2] [nvarchar](max) NULL,
    	[Iso3] [nvarchar](max) NULL,
    	[CreatedDate] [datetime2](7) NULL,
    	[CreatedBy] [nvarchar](max) NULL,
    	[LastModifiedDate] [datetime2](7) NULL,
    	[LastModifiedBy] [nvarchar](max) NULL,
     CONSTRAINT [PK_Countries] PRIMARY KEY CLUSTERED 
    (
    	[Id] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

-- Table [dbo].[Images]
/****** Object:  Table [dbo].[Images]    Script Date: <ignored>******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[dbo].[Images]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Images](
    	[Id] [int] IDENTITY(1,1) NOT NULL,
    	[Url] [nvarchar](4000) NULL,
    	[ProductId] [int] NOT NULL,
    	[PublicCode] [nvarchar](max) NULL,
    	[CreatedDate] [datetime2](7) NULL,
    	[CreatedBy] [nvarchar](max) NULL,
    	[LastModifiedDate] [datetime2](7) NULL,
    	[LastModifiedBy] [nvarchar](max) NULL,
     CONSTRAINT [PK_Images] PRIMARY KEY CLUSTERED 
    (
    	[Id] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

-- Table [dbo].[OrderAddresses]
/****** Object:  Table [dbo].[OrderAddresses]    Script Date: <ignored>******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[dbo].[OrderAddresses]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[OrderAddresses](
    	[Id] [int] IDENTITY(1,1) NOT NULL,
    	[Direccion] [nvarchar](max) NULL,
    	[Ciudad] [nvarchar](max) NULL,
    	[Departamento] [nvarchar](max) NULL,
    	[CodigoPostal] [nvarchar](max) NULL,
    	[Username] [nvarchar](max) NULL,
    	[Pais] [nvarchar](max) NULL,
    	[CreatedDate] [datetime2](7) NULL,
    	[CreatedBy] [nvarchar](max) NULL,
    	[LastModifiedDate] [datetime2](7) NULL,
    	[LastModifiedBy] [nvarchar](max) NULL,
     CONSTRAINT [PK_OrderAddresses] PRIMARY KEY CLUSTERED 
    (
    	[Id] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

-- Table [dbo].[OrderItems]
/****** Object:  Table [dbo].[OrderItems]    Script Date: <ignored>******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[dbo].[OrderItems]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[OrderItems](
    	[Id] [int] IDENTITY(1,1) NOT NULL,
    	[ProductId] [int] NOT NULL,
    	[Precio] [decimal](10, 2) NOT NULL,
    	[Cantidad] [int] NOT NULL,
    	[OrderId] [int] NOT NULL,
    	[ProductItemId] [int] NOT NULL,
    	[ProductNombre] [nvarchar](max) NULL,
    	[ImagenUrl] [nvarchar](max) NULL,
    	[CreatedDate] [datetime2](7) NULL,
    	[CreatedBy] [nvarchar](max) NULL,
    	[LastModifiedDate] [datetime2](7) NULL,
    	[LastModifiedBy] [nvarchar](max) NULL,
     CONSTRAINT [PK_OrderItems] PRIMARY KEY CLUSTERED 
    (
    	[Id] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

-- Table [dbo].[Orders]
/****** Object:  Table [dbo].[Orders]    Script Date: <ignored>******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[dbo].[Orders]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Orders](
    	[Id] [int] IDENTITY(1,1) NOT NULL,
    	[CompradorNombre] [nvarchar](max) NULL,
    	[CompradorUsername] [nvarchar](max) NULL,
    	[OrderAddressId] [int] NULL,
    	[Subtotal] [decimal](10, 2) NOT NULL,
    	[Status] [int] NOT NULL,
    	[Total] [decimal](10, 2) NOT NULL,
    	[Impuesto] [decimal](10, 2) NOT NULL,
    	[PrecioEnvio] [decimal](10, 2) NOT NULL,
    	[PaymentIntentId] [nvarchar](max) NULL,
    	[ClientSecret] [nvarchar](max) NULL,
    	[StripeApiKey] [nvarchar](max) NULL,
    	[CreatedDate] [datetime2](7) NULL,
    	[CreatedBy] [nvarchar](max) NULL,
    	[LastModifiedDate] [datetime2](7) NULL,
    	[LastModifiedBy] [nvarchar](max) NULL,
     CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
    (
    	[Id] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

-- Table [dbo].[Products]
/****** Object:  Table [dbo].[Products]    Script Date: <ignored>******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[dbo].[Products]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Products](
    	[Id] [int] IDENTITY(1,1) NOT NULL,
    	[Nombre] [nvarchar](100) NULL,
    	[Precio] [decimal](10, 2) NOT NULL,
    	[Descripcion] [nvarchar](4000) NULL,
    	[Rating] [int] NOT NULL,
    	[Vendedor] [nvarchar](100) NULL,
    	[Stock] [int] NOT NULL,
    	[Status] [int] NOT NULL,
    	[CategoryId] [int] NOT NULL,
    	[CreatedDate] [datetime2](7) NULL,
    	[CreatedBy] [nvarchar](max) NULL,
    	[LastModifiedDate] [datetime2](7) NULL,
    	[LastModifiedBy] [nvarchar](max) NULL,
     CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
    (
    	[Id] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

-- Table [dbo].[Reviews]
/****** Object:  Table [dbo].[Reviews]    Script Date: <ignored>******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[dbo].[Reviews]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Reviews](
    	[Id] [int] IDENTITY(1,1) NOT NULL,
    	[Nombre] [nvarchar](100) NULL,
    	[Rating] [int] NOT NULL,
    	[Comentario] [nvarchar](4000) NULL,
    	[ProductId] [int] NOT NULL,
    	[CreatedDate] [datetime2](7) NULL,
    	[CreatedBy] [nvarchar](max) NULL,
    	[LastModifiedDate] [datetime2](7) NULL,
    	[LastModifiedBy] [nvarchar](max) NULL,
     CONSTRAINT [PK_Reviews] PRIMARY KEY CLUSTERED 
    (
    	[Id] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

-- Table [dbo].[ShoppingCartItems]
/****** Object:  Table [dbo].[ShoppingCartItems]    Script Date: <ignored>******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[dbo].[ShoppingCartItems]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[ShoppingCartItems](
    	[Id] [int] IDENTITY(1,1) NOT NULL,
    	[Producto] [nvarchar](max) NULL,
    	[Precio] [decimal](10, 2) NOT NULL,
    	[Cantidad] [int] NOT NULL,
    	[Imagen] [nvarchar](max) NULL,
    	[Categoria] [nvarchar](max) NULL,
    	[ShoppingCartMasterId] [uniqueidentifier] NULL,
    	[ShoppingCartId] [int] NOT NULL,
    	[ProductId] [int] NOT NULL,
    	[Stock] [int] NOT NULL,
    	[CreatedDate] [datetime2](7) NULL,
    	[CreatedBy] [nvarchar](max) NULL,
    	[LastModifiedDate] [datetime2](7) NULL,
    	[LastModifiedBy] [nvarchar](max) NULL,
     CONSTRAINT [PK_ShoppingCartItems] PRIMARY KEY CLUSTERED 
    (
    	[Id] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

-- Table [dbo].[ShoppingCarts]
/****** Object:  Table [dbo].[ShoppingCarts]    Script Date: <ignored>******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[dbo].[ShoppingCarts]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[ShoppingCarts](
    	[Id] [int] IDENTITY(1,1) NOT NULL,
    	[ShoppingCartMasterId] [uniqueidentifier] NULL,
    	[CreatedDate] [datetime2](7) NULL,
    	[CreatedBy] [nvarchar](max) NULL,
    	[LastModifiedDate] [datetime2](7) NULL,
    	[LastModifiedBy] [nvarchar](max) NULL,
     CONSTRAINT [PK_ShoppingCarts] PRIMARY KEY CLUSTERED 
    (
    	[Id] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

-- 2. Relaciones / constraints nuevas

IF OBJECT_ID(N'[dbo].[FK_AspNetRoleClaims_AspNetRoles_RoleId]', N'F') IS NULL
BEGIN
    ALTER TABLE [dbo].[AspNetRoleClaims]  WITH CHECK ADD  CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
    REFERENCES [dbo].[AspNetRoles] ([Id])
    ON DELETE CASCADE
END
GO

IF OBJECT_ID(N'[dbo].[FK_AspNetRoleClaims_AspNetRoles_RoleId]', N'F') IS NOT NULL
BEGIN
    ALTER TABLE [dbo].[AspNetRoleClaims] CHECK CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId]
END
GO

IF OBJECT_ID(N'[dbo].[FK_AspNetUserClaims_AspNetUsers_UserId]', N'F') IS NULL
BEGIN
    ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY([UserId])
    REFERENCES [dbo].[AspNetUsers] ([Id])
    ON DELETE CASCADE
END
GO

IF OBJECT_ID(N'[dbo].[FK_AspNetUserClaims_AspNetUsers_UserId]', N'F') IS NOT NULL
BEGIN
    ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId]
END
GO

IF OBJECT_ID(N'[dbo].[FK_AspNetUserLogins_AspNetUsers_UserId]', N'F') IS NULL
BEGIN
    ALTER TABLE [dbo].[AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY([UserId])
    REFERENCES [dbo].[AspNetUsers] ([Id])
    ON DELETE CASCADE
END
GO

IF OBJECT_ID(N'[dbo].[FK_AspNetUserLogins_AspNetUsers_UserId]', N'F') IS NOT NULL
BEGIN
    ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId]
END
GO

IF OBJECT_ID(N'[dbo].[FK_AspNetUserRoles_AspNetRoles_RoleId]', N'F') IS NULL
BEGIN
    ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
    REFERENCES [dbo].[AspNetRoles] ([Id])
    ON DELETE CASCADE
END
GO

IF OBJECT_ID(N'[dbo].[FK_AspNetUserRoles_AspNetRoles_RoleId]', N'F') IS NOT NULL
BEGIN
    ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId]
END
GO

IF OBJECT_ID(N'[dbo].[FK_AspNetUserRoles_AspNetUsers_UserId]', N'F') IS NULL
BEGIN
    ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY([UserId])
    REFERENCES [dbo].[AspNetUsers] ([Id])
    ON DELETE CASCADE
END
GO

IF OBJECT_ID(N'[dbo].[FK_AspNetUserRoles_AspNetUsers_UserId]', N'F') IS NOT NULL
BEGIN
    ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId]
END
GO

IF OBJECT_ID(N'[dbo].[FK_AspNetUserTokens_AspNetUsers_UserId]', N'F') IS NULL
BEGIN
    ALTER TABLE [dbo].[AspNetUserTokens]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY([UserId])
    REFERENCES [dbo].[AspNetUsers] ([Id])
    ON DELETE CASCADE
END
GO

IF OBJECT_ID(N'[dbo].[FK_AspNetUserTokens_AspNetUsers_UserId]', N'F') IS NOT NULL
BEGIN
    ALTER TABLE [dbo].[AspNetUserTokens] CHECK CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId]
END
GO

IF OBJECT_ID(N'[dbo].[FK_Images_Products_ProductId]', N'F') IS NULL
BEGIN
    ALTER TABLE [dbo].[Images]  WITH CHECK ADD  CONSTRAINT [FK_Images_Products_ProductId] FOREIGN KEY([ProductId])
    REFERENCES [dbo].[Products] ([Id])
    ON DELETE CASCADE
END
GO

IF OBJECT_ID(N'[dbo].[FK_Images_Products_ProductId]', N'F') IS NOT NULL
BEGIN
    ALTER TABLE [dbo].[Images] CHECK CONSTRAINT [FK_Images_Products_ProductId]
END
GO

IF OBJECT_ID(N'[dbo].[FK_OrderItems_Orders_OrderId]', N'F') IS NULL
BEGIN
    ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD  CONSTRAINT [FK_OrderItems_Orders_OrderId] FOREIGN KEY([OrderId])
    REFERENCES [dbo].[Orders] ([Id])
    ON DELETE CASCADE
END
GO

IF OBJECT_ID(N'[dbo].[FK_OrderItems_Orders_OrderId]', N'F') IS NOT NULL
BEGIN
    ALTER TABLE [dbo].[OrderItems] CHECK CONSTRAINT [FK_OrderItems_Orders_OrderId]
END
GO

IF OBJECT_ID(N'[dbo].[FK_OrderItems_Products_ProductId]', N'F') IS NULL
BEGIN
    ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD  CONSTRAINT [FK_OrderItems_Products_ProductId] FOREIGN KEY([ProductId])
    REFERENCES [dbo].[Products] ([Id])
    ON DELETE CASCADE
END
GO

IF OBJECT_ID(N'[dbo].[FK_OrderItems_Products_ProductId]', N'F') IS NOT NULL
BEGIN
    ALTER TABLE [dbo].[OrderItems] CHECK CONSTRAINT [FK_OrderItems_Products_ProductId]
END
GO

IF OBJECT_ID(N'[dbo].[FK_Orders_OrderAddresses_OrderAddressId]', N'F') IS NULL
BEGIN
    ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_OrderAddresses_OrderAddressId] FOREIGN KEY([OrderAddressId])
    REFERENCES [dbo].[OrderAddresses] ([Id])
END
GO

IF OBJECT_ID(N'[dbo].[FK_Orders_OrderAddresses_OrderAddressId]', N'F') IS NOT NULL
BEGIN
    ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_OrderAddresses_OrderAddressId]
END
GO

IF OBJECT_ID(N'[dbo].[FK_Products_Categories_CategoryId]', N'F') IS NULL
BEGIN
    ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Products_Categories_CategoryId] FOREIGN KEY([CategoryId])
    REFERENCES [dbo].[Categories] ([Id])
END
GO

IF OBJECT_ID(N'[dbo].[FK_Products_Categories_CategoryId]', N'F') IS NOT NULL
BEGIN
    ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_Categories_CategoryId]
END
GO

IF OBJECT_ID(N'[dbo].[FK_Reviews_Products_ProductId]', N'F') IS NULL
BEGIN
    ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD  CONSTRAINT [FK_Reviews_Products_ProductId] FOREIGN KEY([ProductId])
    REFERENCES [dbo].[Products] ([Id])
    ON DELETE CASCADE
END
GO

IF OBJECT_ID(N'[dbo].[FK_Reviews_Products_ProductId]', N'F') IS NOT NULL
BEGIN
    ALTER TABLE [dbo].[Reviews] CHECK CONSTRAINT [FK_Reviews_Products_ProductId]
END
GO

IF OBJECT_ID(N'[dbo].[FK_ShoppingCartItems_ShoppingCarts_ShoppingCartId]', N'F') IS NULL
BEGIN
    ALTER TABLE [dbo].[ShoppingCartItems]  WITH CHECK ADD  CONSTRAINT [FK_ShoppingCartItems_ShoppingCarts_ShoppingCartId] FOREIGN KEY([ShoppingCartId])
    REFERENCES [dbo].[ShoppingCarts] ([Id])
    ON DELETE CASCADE
END
GO

IF OBJECT_ID(N'[dbo].[FK_ShoppingCartItems_ShoppingCarts_ShoppingCartId]', N'F') IS NOT NULL
BEGIN
    ALTER TABLE [dbo].[ShoppingCartItems] CHECK CONSTRAINT [FK_ShoppingCartItems_ShoppingCarts_ShoppingCartId]
END
GO

-- 3. Indices nuevos

-- Index [IX_AspNetRoleClaims_RoleId] ON [dbo].[AspNetRoleClaims]
/****** Object:  Index [IX_AspNetRoleClaims_RoleId]    Script Date: <ignored>******/
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_AspNetRoleClaims_RoleId' AND object_id = OBJECT_ID(N'[dbo].[AspNetRoleClaims]'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_AspNetRoleClaims_RoleId] ON [dbo].[AspNetRoleClaims]
    (
    	[RoleId] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
GO

-- Index [RoleNameIndex] ON [dbo].[AspNetRoles]
/****** Object:  Index [RoleNameIndex]    Script Date: <ignored>******/
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'RoleNameIndex' AND object_id = OBJECT_ID(N'[dbo].[AspNetRoles]'))
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex] ON [dbo].[AspNetRoles]
    (
    	[NormalizedName] ASC
    )
    WHERE ([NormalizedName] IS NOT NULL)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
GO

-- Index [IX_AspNetUserClaims_UserId] ON [dbo].[AspNetUserClaims]
/****** Object:  Index [IX_AspNetUserClaims_UserId]    Script Date: <ignored>******/
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_AspNetUserClaims_UserId' AND object_id = OBJECT_ID(N'[dbo].[AspNetUserClaims]'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_AspNetUserClaims_UserId] ON [dbo].[AspNetUserClaims]
    (
    	[UserId] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
GO

-- Index [IX_AspNetUserLogins_UserId] ON [dbo].[AspNetUserLogins]
/****** Object:  Index [IX_AspNetUserLogins_UserId]    Script Date: <ignored>******/
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_AspNetUserLogins_UserId' AND object_id = OBJECT_ID(N'[dbo].[AspNetUserLogins]'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_AspNetUserLogins_UserId] ON [dbo].[AspNetUserLogins]
    (
    	[UserId] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
GO

-- Index [IX_AspNetUserRoles_RoleId] ON [dbo].[AspNetUserRoles]
/****** Object:  Index [IX_AspNetUserRoles_RoleId]    Script Date: <ignored>******/
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_AspNetUserRoles_RoleId' AND object_id = OBJECT_ID(N'[dbo].[AspNetUserRoles]'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_AspNetUserRoles_RoleId] ON [dbo].[AspNetUserRoles]
    (
    	[RoleId] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
GO

-- Index [EmailIndex] ON [dbo].[AspNetUsers]
/****** Object:  Index [EmailIndex]    Script Date: <ignored>******/
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'EmailIndex' AND object_id = OBJECT_ID(N'[dbo].[AspNetUsers]'))
BEGIN
    CREATE NONCLUSTERED INDEX [EmailIndex] ON [dbo].[AspNetUsers]
    (
    	[NormalizedEmail] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
GO

-- Index [UserNameIndex] ON [dbo].[AspNetUsers]
/****** Object:  Index [UserNameIndex]    Script Date: <ignored>******/
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UserNameIndex' AND object_id = OBJECT_ID(N'[dbo].[AspNetUsers]'))
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex] ON [dbo].[AspNetUsers]
    (
    	[NormalizedUserName] ASC
    )
    WHERE ([NormalizedUserName] IS NOT NULL)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
GO

-- Index [IX_Images_ProductId] ON [dbo].[Images]
/****** Object:  Index [IX_Images_ProductId]    Script Date: <ignored>******/
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Images_ProductId' AND object_id = OBJECT_ID(N'[dbo].[Images]'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_Images_ProductId] ON [dbo].[Images]
    (
    	[ProductId] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
GO

-- Index [IX_OrderItems_OrderId] ON [dbo].[OrderItems]
/****** Object:  Index [IX_OrderItems_OrderId]    Script Date: <ignored>******/
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_OrderItems_OrderId' AND object_id = OBJECT_ID(N'[dbo].[OrderItems]'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_OrderItems_OrderId] ON [dbo].[OrderItems]
    (
    	[OrderId] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
GO

-- Index [IX_OrderItems_ProductId] ON [dbo].[OrderItems]
/****** Object:  Index [IX_OrderItems_ProductId]    Script Date: <ignored>******/
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_OrderItems_ProductId' AND object_id = OBJECT_ID(N'[dbo].[OrderItems]'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_OrderItems_ProductId] ON [dbo].[OrderItems]
    (
    	[ProductId] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
GO

-- Index [IX_Orders_OrderAddressId] ON [dbo].[Orders]
/****** Object:  Index [IX_Orders_OrderAddressId]    Script Date: <ignored>******/
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Orders_OrderAddressId' AND object_id = OBJECT_ID(N'[dbo].[Orders]'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_Orders_OrderAddressId] ON [dbo].[Orders]
    (
    	[OrderAddressId] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
GO

-- Index [IX_Products_CategoryId] ON [dbo].[Products]
/****** Object:  Index [IX_Products_CategoryId]    Script Date: <ignored>******/
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Products_CategoryId' AND object_id = OBJECT_ID(N'[dbo].[Products]'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_Products_CategoryId] ON [dbo].[Products]
    (
    	[CategoryId] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
GO

-- Index [IX_Reviews_ProductId] ON [dbo].[Reviews]
/****** Object:  Index [IX_Reviews_ProductId]    Script Date: <ignored>******/
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Reviews_ProductId' AND object_id = OBJECT_ID(N'[dbo].[Reviews]'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_Reviews_ProductId] ON [dbo].[Reviews]
    (
    	[ProductId] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
GO

-- Index [IX_ShoppingCartItems_ShoppingCartId] ON [dbo].[ShoppingCartItems]
/****** Object:  Index [IX_ShoppingCartItems_ShoppingCartId]    Script Date: <ignored>******/
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_ShoppingCartItems_ShoppingCartId' AND object_id = OBJECT_ID(N'[dbo].[ShoppingCartItems]'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_ShoppingCartItems_ShoppingCartId] ON [dbo].[ShoppingCartItems]
    (
    	[ShoppingCartId] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
GO

-- Fin de cambios

