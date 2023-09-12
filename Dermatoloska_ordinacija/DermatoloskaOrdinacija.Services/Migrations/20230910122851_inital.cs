using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace DermatoloskaOrdinacija.Services.Migrations
{
    /// <inheritdoc />
    public partial class inital : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Spol",
                columns: table => new
                {
                    SpolID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Spol__636459EFE65B4C91", x => x.SpolID);
                });

            migrationBuilder.CreateTable(
                name: "TipKorisnika",
                columns: table => new
                {
                    TipKorisnikaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Tip = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__TipKoris__6CE42F0EC901C725", x => x.TipKorisnikaID);
                });

            migrationBuilder.CreateTable(
                name: "VrstaProizvoda",
                columns: table => new
                {
                    VrstaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__VrstaPro__42CB8F0F6304088C", x => x.VrstaID);
                });

            migrationBuilder.CreateTable(
                name: "Korisnik",
                columns: table => new
                {
                    KorisnikID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Ime = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Prezime = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Username = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true),
                    Email = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Telefon = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true),
                    Adresa = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true),
                    LozinkaSalt = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    LozinkaHash = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    TipKorisnikaID = table.Column<int>(type: "int", nullable: true),
                    SpolID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Korisnik__80B06D61EA5C9458", x => x.KorisnikID);
                    table.ForeignKey(
                        name: "FK__Korisnik__SpolID__44FF419A",
                        column: x => x.SpolID,
                        principalTable: "Spol",
                        principalColumn: "SpolID");
                    table.ForeignKey(
                        name: "FK__Korisnik__TipKor__440B1D61",
                        column: x => x.TipKorisnikaID,
                        principalTable: "TipKorisnika",
                        principalColumn: "TipKorisnikaID");
                });

            migrationBuilder.CreateTable(
                name: "Proizvod",
                columns: table => new
                {
                    ProizvodID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Sifra = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Cijena = table.Column<decimal>(type: "decimal(10,2)", nullable: true),
                    VrstaID = table.Column<int>(type: "int", nullable: true),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    StateMachine = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Proizvod__21A8BE18A0094A0D", x => x.ProizvodID);
                    table.ForeignKey(
                        name: "FK__Proizvod__VrstaI__49C3F6B7",
                        column: x => x.VrstaID,
                        principalTable: "VrstaProizvoda",
                        principalColumn: "VrstaID");
                });

            migrationBuilder.CreateTable(
                name: "Narudzba",
                columns: table => new
                {
                    NarudzbaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    BrojNarudzbe = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: true),
                    Datum = table.Column<DateTime>(type: "date", nullable: true),
                    Status = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true),
                    KorisnikID = table.Column<int>(type: "int", nullable: true),
                    Iznos = table.Column<double>(type: "float", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Narudzba__FBEC13572CBE5E47", x => x.NarudzbaID);
                    table.ForeignKey(
                        name: "FK__Narudzba__Korisn__571DF1D5",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikID");
                });

            migrationBuilder.CreateTable(
                name: "Novost",
                columns: table => new
                {
                    NovostID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naslov = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Sadrzaj = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    DatumObjave = table.Column<DateTime>(type: "date", nullable: true),
                    KorisnikID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Novost__967A351C2A39557C", x => x.NovostID);
                    table.ForeignKey(
                        name: "FK__Novost__Korisnik__68487DD7",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikID");
                });

            migrationBuilder.CreateTable(
                name: "Termin",
                columns: table => new
                {
                    TerminID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Datum = table.Column<DateTime>(type: "datetime", nullable: true),
                    KorisnikID_doktor = table.Column<int>(type: "int", nullable: true),
                    KorisnikID_pacijent = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Termin__42126CB55F98E1ED", x => x.TerminID);
                    table.ForeignKey(
                        name: "FK_korisnik_termin_doktor",
                        column: x => x.KorisnikID_doktor,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikID");
                    table.ForeignKey(
                        name: "FK_korisnik_termin_pacijent",
                        column: x => x.KorisnikID_pacijent,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikID");
                });

            migrationBuilder.CreateTable(
                name: "ZdravstveniKarton",
                columns: table => new
                {
                    ZdravstveniKartonID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Sadrzaj = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    KorisnikID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Zdravstv__8A4E4706D0C1A0EA", x => x.ZdravstveniKartonID);
                    table.ForeignKey(
                        name: "FK__Zdravstve__Koris__656C112C",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikID");
                });

            migrationBuilder.CreateTable(
                name: "Dojam",
                columns: table => new
                {
                    DojamID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    IsLiked = table.Column<bool>(type: "bit", nullable: true),
                    ProizvodID = table.Column<int>(type: "int", nullable: true),
                    KorisnikID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Dojam__FDF96C501403C227", x => x.DojamID);
                    table.ForeignKey(
                        name: "FK__Dojam__KorisnikI__5EBF139D",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikID");
                    table.ForeignKey(
                        name: "FK__Dojam__ProizvodI__5DCAEF64",
                        column: x => x.ProizvodID,
                        principalTable: "Proizvod",
                        principalColumn: "ProizvodID");
                });

            migrationBuilder.CreateTable(
                name: "OmiljeniProizvodi",
                columns: table => new
                {
                    OmiljeniProizvodID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    DatumDodavanja = table.Column<DateTime>(type: "date", nullable: true),
                    ProizvodID = table.Column<int>(type: "int", nullable: true),
                    KorisnikID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Omiljeni__C509DCAB45EDFCBF", x => x.OmiljeniProizvodID);
                    table.ForeignKey(
                        name: "FK__OmiljeniP__Koris__4D94879B",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikID");
                    table.ForeignKey(
                        name: "FK__OmiljeniP__Proiz__4CA06362",
                        column: x => x.ProizvodID,
                        principalTable: "Proizvod",
                        principalColumn: "ProizvodID");
                });

            migrationBuilder.CreateTable(
                name: "Recenzija",
                columns: table => new
                {
                    RecenzijaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Sadrzaj = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Datum = table.Column<DateTime>(type: "date", nullable: true),
                    ProizvodID = table.Column<int>(type: "int", nullable: true),
                    KorisnikID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Recenzij__D36C60909B0DCE80", x => x.RecenzijaID);
                    table.ForeignKey(
                        name: "FK__Recenzija__Koris__628FA481",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikID");
                    table.ForeignKey(
                        name: "FK__Recenzija__Proiz__619B8048",
                        column: x => x.ProizvodID,
                        principalTable: "Proizvod",
                        principalColumn: "ProizvodID");
                });

            migrationBuilder.CreateTable(
                name: "StavkaNarudzbe",
                columns: table => new
                {
                    StavkaNarudzbeID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Kolicina = table.Column<int>(type: "int", nullable: true),
                    NarudzbaID = table.Column<int>(type: "int", nullable: true),
                    ProizvodID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__StavkaNa__39E50D50F39346E7", x => x.StavkaNarudzbeID);
                    table.ForeignKey(
                        name: "FK__StavkaNar__Narud__59FA5E80",
                        column: x => x.NarudzbaID,
                        principalTable: "Narudzba",
                        principalColumn: "NarudzbaID");
                    table.ForeignKey(
                        name: "FK__StavkaNar__Proiz__5AEE82B9",
                        column: x => x.ProizvodID,
                        principalTable: "Proizvod",
                        principalColumn: "ProizvodID");
                });

            migrationBuilder.CreateTable(
                name: "Transakcija",
                columns: table => new
                {
                    TranskcijaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NarudzbaID = table.Column<int>(type: "int", nullable: true),
                    Iznos = table.Column<double>(type: "float", nullable: true),
                    status_transakcije = table.Column<string>(type: "varchar(255)", unicode: false, maxLength: 255, nullable: true),
                    trans_id = table.Column<string>(type: "varchar(255)", unicode: false, maxLength: 255, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Transakc__7403ABDADAAB4592", x => x.TranskcijaId);
                    table.ForeignKey(
                        name: "FK__Transakci__Narud__02FC7413",
                        column: x => x.NarudzbaID,
                        principalTable: "Narudzba",
                        principalColumn: "NarudzbaID");
                });

            migrationBuilder.InsertData(
                table: "Spol",
                columns: new[] { "SpolID", "Naziv" },
                values: new object[,]
                {
                    { 1, "M" },
                    { 2, "F" }
                });

            migrationBuilder.InsertData(
                table: "TipKorisnika",
                columns: new[] { "TipKorisnikaID", "Tip" },
                values: new object[,]
                {
                    { 1, "Pacijent" },
                    { 2, "Uposlenik" }
                });

            migrationBuilder.InsertData(
                table: "VrstaProizvoda",
                columns: new[] { "VrstaID", "Naziv" },
                values: new object[,]
                {
                    { 1, "Krema" },
                    { 2, "Losion" }
                });

            migrationBuilder.InsertData(
                table: "Korisnik",
                columns: new[] { "KorisnikID", "Adresa", "Email", "Ime", "LozinkaHash", "LozinkaSalt", "Prezime", "SpolID", "Telefon", "TipKorisnikaID", "Username" },
                values: new object[,]
                {
                    { 1, "test", "uposlenik@gmail.com", "uposlenik", "vCJEzMq01/y2WfxocUBTkBMJ0i0=", "cbRh4cvy1djCQHeiqTcggg==", "uposlenik", 1, "0612345678", 2, "uposlenik" },
                    { 2, "test", "pacijent@gmail.com", "pacijent", "ZEGY1lcTmU1LHPvmEagd/1aXq6o=", "5baNMRJ0C3G1HK5A7lybxQ==", "pacijent", 2, "0612345678", 1, "pacijent" }
                });

            migrationBuilder.InsertData(
                table: "Proizvod",
                columns: new[] { "ProizvodID", "Cijena", "Naziv", "Sifra", "Slika", "StateMachine", "VrstaID" },
                values: new object[,]
                {
                    { 1, 50m, "Krema za akne", "555A", null, "draft", 1 },
                    { 2, 40m, "Losion za lice", "555B", null, "draft", 2 },
                    { 3, 40m, "Krema za lice", "555B", null, "draft", 1 }
                });

            migrationBuilder.InsertData(
                table: "Dojam",
                columns: new[] { "DojamID", "IsLiked", "KorisnikID", "ProizvodID" },
                values: new object[] { 1, true, 2, 1 });

            migrationBuilder.InsertData(
                table: "Narudzba",
                columns: new[] { "NarudzbaID", "BrojNarudzbe", "Datum", "Iznos", "KorisnikID", "Status" },
                values: new object[] { 1, "#1", new DateTime(2023, 9, 10, 14, 28, 51, 563, DateTimeKind.Local).AddTicks(9188), 90.0, 2, "Pending" });

            migrationBuilder.InsertData(
                table: "Novost",
                columns: new[] { "NovostID", "DatumObjave", "KorisnikID", "Naslov", "Sadrzaj" },
                values: new object[] { 1, new DateTime(2023, 9, 10, 14, 28, 51, 563, DateTimeKind.Local).AddTicks(9154), 1, "Test naslov", "Test sadrzaj" });

            migrationBuilder.InsertData(
                table: "OmiljeniProizvodi",
                columns: new[] { "OmiljeniProizvodID", "DatumDodavanja", "KorisnikID", "ProizvodID" },
                values: new object[] { 1, new DateTime(2023, 9, 10, 14, 28, 51, 563, DateTimeKind.Local).AddTicks(9171), 2, 1 });

            migrationBuilder.InsertData(
                table: "Recenzija",
                columns: new[] { "RecenzijaID", "Datum", "KorisnikID", "ProizvodID", "Sadrzaj" },
                values: new object[] { 1, new DateTime(2023, 9, 10, 14, 28, 51, 563, DateTimeKind.Local).AddTicks(9070), 2, 1, "Test recenzija" });

            migrationBuilder.InsertData(
                table: "Termin",
                columns: new[] { "TerminID", "Datum", "KorisnikID_doktor", "KorisnikID_pacijent" },
                values: new object[] { 1, new DateTime(2023, 9, 10, 14, 28, 51, 563, DateTimeKind.Local).AddTicks(9135), 1, 2 });

            migrationBuilder.InsertData(
                table: "ZdravstveniKarton",
                columns: new[] { "ZdravstveniKartonID", "KorisnikID", "Sadrzaj" },
                values: new object[] { 1, 2, "Test sadrzaj" });

            migrationBuilder.InsertData(
                table: "StavkaNarudzbe",
                columns: new[] { "StavkaNarudzbeID", "Kolicina", "NarudzbaID", "ProizvodID" },
                values: new object[,]
                {
                    { 1, 1, 1, 1 },
                    { 2, 1, 1, 2 }
                });

            migrationBuilder.InsertData(
                table: "Transakcija",
                columns: new[] { "TranskcijaId", "Iznos", "NarudzbaID", "status_transakcije", "trans_id" },
                values: new object[] { 1, 90.0, 1, "approved", "PAYID-MT3WXSA82J975902T912173T" });

            migrationBuilder.CreateIndex(
                name: "IX_Dojam_KorisnikID",
                table: "Dojam",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Dojam_ProizvodID",
                table: "Dojam",
                column: "ProizvodID");

            migrationBuilder.CreateIndex(
                name: "IX_Korisnik_SpolID",
                table: "Korisnik",
                column: "SpolID");

            migrationBuilder.CreateIndex(
                name: "IX_Korisnik_TipKorisnikaID",
                table: "Korisnik",
                column: "TipKorisnikaID");

            migrationBuilder.CreateIndex(
                name: "IX_Narudzba_KorisnikID",
                table: "Narudzba",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Novost_KorisnikID",
                table: "Novost",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_OmiljeniProizvodi_KorisnikID",
                table: "OmiljeniProizvodi",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_OmiljeniProizvodi_ProizvodID",
                table: "OmiljeniProizvodi",
                column: "ProizvodID");

            migrationBuilder.CreateIndex(
                name: "IX_Proizvod_VrstaID",
                table: "Proizvod",
                column: "VrstaID");

            migrationBuilder.CreateIndex(
                name: "IX_Recenzija_KorisnikID",
                table: "Recenzija",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Recenzija_ProizvodID",
                table: "Recenzija",
                column: "ProizvodID");

            migrationBuilder.CreateIndex(
                name: "IX_StavkaNarudzbe_NarudzbaID",
                table: "StavkaNarudzbe",
                column: "NarudzbaID");

            migrationBuilder.CreateIndex(
                name: "IX_StavkaNarudzbe_ProizvodID",
                table: "StavkaNarudzbe",
                column: "ProizvodID");

            migrationBuilder.CreateIndex(
                name: "IX_Termin_KorisnikID_doktor",
                table: "Termin",
                column: "KorisnikID_doktor");

            migrationBuilder.CreateIndex(
                name: "IX_Termin_KorisnikID_pacijent",
                table: "Termin",
                column: "KorisnikID_pacijent");

            migrationBuilder.CreateIndex(
                name: "IX_Transakcija_NarudzbaID",
                table: "Transakcija",
                column: "NarudzbaID");

            migrationBuilder.CreateIndex(
                name: "IX_ZdravstveniKarton_KorisnikID",
                table: "ZdravstveniKarton",
                column: "KorisnikID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Dojam");

            migrationBuilder.DropTable(
                name: "Novost");

            migrationBuilder.DropTable(
                name: "OmiljeniProizvodi");

            migrationBuilder.DropTable(
                name: "Recenzija");

            migrationBuilder.DropTable(
                name: "StavkaNarudzbe");

            migrationBuilder.DropTable(
                name: "Termin");

            migrationBuilder.DropTable(
                name: "Transakcija");

            migrationBuilder.DropTable(
                name: "ZdravstveniKarton");

            migrationBuilder.DropTable(
                name: "Proizvod");

            migrationBuilder.DropTable(
                name: "Narudzba");

            migrationBuilder.DropTable(
                name: "VrstaProizvoda");

            migrationBuilder.DropTable(
                name: "Korisnik");

            migrationBuilder.DropTable(
                name: "Spol");

            migrationBuilder.DropTable(
                name: "TipKorisnika");
        }
    }
}
