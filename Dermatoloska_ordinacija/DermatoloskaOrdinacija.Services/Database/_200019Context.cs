using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace DermatoloskaOrdinacija.Services.Database;

public partial class _200019Context : DbContext
{
    public _200019Context()
    {
    }

    public _200019Context(DbContextOptions<_200019Context> options)
        : base(options)
    {
    }

    public virtual DbSet<Dojam> Dojams { get; set; }

    public virtual DbSet<Korisnik> Korisniks { get; set; }

    public virtual DbSet<Narudzba> Narudzbas { get; set; }

    public virtual DbSet<Novost> Novosts { get; set; }

    public virtual DbSet<OmiljeniProizvodi> OmiljeniProizvodis { get; set; }

    public virtual DbSet<Proizvod> Proizvods { get; set; }

    public virtual DbSet<Recenzija> Recenzijas { get; set; }

    public virtual DbSet<RecommendResult> RecommendResults { get; set; }

    public virtual DbSet<Spol> Spols { get; set; }

    public virtual DbSet<StavkaNarudzbe> StavkaNarudzbes { get; set; }

    public virtual DbSet<Termin> Termins { get; set; }

    public virtual DbSet<TipKorisnika> TipKorisnikas { get; set; }

    public virtual DbSet<Transakcija> Transakcijas { get; set; }

    public virtual DbSet<VrstaProizvodum> VrstaProizvoda { get; set; }

    public virtual DbSet<ZdravstveniKarton> ZdravstveniKartons { get; set; }

    /*
    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server= DESKTOP-R8CFAE7;Database=_200019;Trusted_Connection=True;TrustServerCertificate=True");

    */
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Dojam>(entity =>
        {
            entity.HasKey(e => e.DojamId).HasName("PK__Dojam__FDF96C501403C227");

            entity.ToTable("Dojam");

            entity.HasIndex(e => e.KorisnikId, "IX_Dojam_KorisnikID");

            entity.HasIndex(e => e.ProizvodId, "IX_Dojam_ProizvodID");

            entity.Property(e => e.DojamId).HasColumnName("DojamID");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.ProizvodId).HasColumnName("ProizvodID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Dojams)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__Dojam__KorisnikI__5EBF139D");

            entity.HasOne(d => d.Proizvod).WithMany(p => p.Dojams)
                .HasForeignKey(d => d.ProizvodId)
                .HasConstraintName("FK__Dojam__ProizvodI__5DCAEF64");
        });

        modelBuilder.Entity<Korisnik>(entity =>
        {
            entity.HasKey(e => e.KorisnikId).HasName("PK__Korisnik__80B06D61EA5C9458");

            entity.ToTable("Korisnik");

            entity.HasIndex(e => e.SpolId, "IX_Korisnik_SpolID");

            entity.HasIndex(e => e.TipKorisnikaId, "IX_Korisnik_TipKorisnikaID");

            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.Adresa).HasMaxLength(20);
            entity.Property(e => e.Email).HasMaxLength(50);
            entity.Property(e => e.Ime).HasMaxLength(50);
            entity.Property(e => e.Prezime).HasMaxLength(50);
            entity.Property(e => e.SpolId).HasColumnName("SpolID");
            entity.Property(e => e.Telefon).HasMaxLength(20);
            entity.Property(e => e.TipKorisnikaId).HasColumnName("TipKorisnikaID");
            entity.Property(e => e.Username).HasMaxLength(20);

            entity.HasOne(d => d.Spol).WithMany(p => p.Korisniks)
                .HasForeignKey(d => d.SpolId)
                .HasConstraintName("FK__Korisnik__SpolID__44FF419A");

            entity.HasOne(d => d.TipKorisnika).WithMany(p => p.Korisniks)
                .HasForeignKey(d => d.TipKorisnikaId)
                .HasConstraintName("FK__Korisnik__TipKor__440B1D61");
        });

        modelBuilder.Entity<Narudzba>(entity =>
        {
            entity.HasKey(e => e.NarudzbaId).HasName("PK__Narudzba__FBEC13572CBE5E47");

            entity.ToTable("Narudzba");

            entity.HasIndex(e => e.KorisnikId, "IX_Narudzba_KorisnikID");

            entity.Property(e => e.NarudzbaId).HasColumnName("NarudzbaID");
            entity.Property(e => e.BrojNarudzbe).HasMaxLength(10);
            entity.Property(e => e.Datum).HasColumnType("date");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.Status).HasMaxLength(20);

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Narudzbas)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__Narudzba__Korisn__571DF1D5");
        });

        modelBuilder.Entity<Novost>(entity =>
        {
            entity.HasKey(e => e.NovostId).HasName("PK__Novost__967A351C2A39557C");

            entity.ToTable("Novost");

            entity.HasIndex(e => e.KorisnikId, "IX_Novost_KorisnikID");

            entity.Property(e => e.NovostId).HasColumnName("NovostID");
            entity.Property(e => e.DatumObjave).HasColumnType("date");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.Naslov).HasMaxLength(50);

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Novosts)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__Novost__Korisnik__68487DD7");
        });

        modelBuilder.Entity<OmiljeniProizvodi>(entity =>
        {
            entity.HasKey(e => e.OmiljeniProizvodId).HasName("PK__Omiljeni__C509DCAB45EDFCBF");

            entity.ToTable("OmiljeniProizvodi");

            entity.HasIndex(e => e.KorisnikId, "IX_OmiljeniProizvodi_KorisnikID");

            entity.HasIndex(e => e.ProizvodId, "IX_OmiljeniProizvodi_ProizvodID");

            entity.Property(e => e.OmiljeniProizvodId).HasColumnName("OmiljeniProizvodID");
            entity.Property(e => e.DatumDodavanja).HasColumnType("date");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.ProizvodId).HasColumnName("ProizvodID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.OmiljeniProizvodis)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__OmiljeniP__Koris__4D94879B");

            entity.HasOne(d => d.Proizvod).WithMany(p => p.OmiljeniProizvodis)
                .HasForeignKey(d => d.ProizvodId)
                .HasConstraintName("FK__OmiljeniP__Proiz__4CA06362");
        });

        modelBuilder.Entity<Proizvod>(entity =>
        {
            entity.HasKey(e => e.ProizvodId).HasName("PK__Proizvod__21A8BE18A0094A0D");

            entity.ToTable("Proizvod");

            entity.HasIndex(e => e.VrstaId, "IX_Proizvod_VrstaID");

            entity.Property(e => e.ProizvodId).HasColumnName("ProizvodID");
            entity.Property(e => e.Cijena).HasColumnType("decimal(10, 2)");
            entity.Property(e => e.Naziv).HasMaxLength(50);
            entity.Property(e => e.StateMachine).HasMaxLength(50);
            entity.Property(e => e.VrstaId).HasColumnName("VrstaID");

            entity.HasOne(d => d.Vrsta).WithMany(p => p.Proizvods)
                .HasForeignKey(d => d.VrstaId)
                .HasConstraintName("FK__Proizvod__VrstaI__49C3F6B7");
        });

        modelBuilder.Entity<Recenzija>(entity =>
        {
            entity.HasKey(e => e.RecenzijaId).HasName("PK__Recenzij__D36C60909B0DCE80");

            entity.ToTable("Recenzija");

            entity.HasIndex(e => e.KorisnikId, "IX_Recenzija_KorisnikID");

            entity.HasIndex(e => e.ProizvodId, "IX_Recenzija_ProizvodID");

            entity.Property(e => e.RecenzijaId).HasColumnName("RecenzijaID");
            entity.Property(e => e.Datum).HasColumnType("date");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.ProizvodId).HasColumnName("ProizvodID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Recenzijas)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__Recenzija__Koris__628FA481");

            entity.HasOne(d => d.Proizvod).WithMany(p => p.Recenzijas)
                .HasForeignKey(d => d.ProizvodId)
                .HasConstraintName("FK__Recenzija__Proiz__619B8048");
        });

        modelBuilder.Entity<RecommendResult>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Recommen__3214EC0798938C1E");

            entity.ToTable("RecommendResult");
        });

        modelBuilder.Entity<Spol>(entity =>
        {
            entity.HasKey(e => e.SpolId).HasName("PK__Spol__636459EFE65B4C91");

            entity.ToTable("Spol");

            entity.Property(e => e.SpolId).HasColumnName("SpolID");
            entity.Property(e => e.Naziv).HasMaxLength(10);
        });

        modelBuilder.Entity<StavkaNarudzbe>(entity =>
        {
            entity.HasKey(e => e.StavkaNarudzbeId).HasName("PK__StavkaNa__39E50D50F39346E7");

            entity.ToTable("StavkaNarudzbe");

            entity.HasIndex(e => e.NarudzbaId, "IX_StavkaNarudzbe_NarudzbaID");

            entity.HasIndex(e => e.ProizvodId, "IX_StavkaNarudzbe_ProizvodID");

            entity.Property(e => e.StavkaNarudzbeId).HasColumnName("StavkaNarudzbeID");
            entity.Property(e => e.NarudzbaId).HasColumnName("NarudzbaID");
            entity.Property(e => e.ProizvodId).HasColumnName("ProizvodID");

            entity.HasOne(d => d.Narudzba).WithMany(p => p.StavkaNarudzbes)
                .HasForeignKey(d => d.NarudzbaId)
                .HasConstraintName("FK__StavkaNar__Narud__59FA5E80");

            entity.HasOne(d => d.Proizvod).WithMany(p => p.StavkaNarudzbes)
                .HasForeignKey(d => d.ProizvodId)
                .HasConstraintName("FK__StavkaNar__Proiz__5AEE82B9");
        });

        modelBuilder.Entity<Termin>(entity =>
        {
            entity.HasKey(e => e.TerminId).HasName("PK__Termin__42126CB55F98E1ED");

            entity.ToTable("Termin");

            entity.HasIndex(e => e.KorisnikIdDoktor, "IX_Termin_KorisnikID_doktor");

            entity.HasIndex(e => e.KorisnikIdPacijent, "IX_Termin_KorisnikID_pacijent");

            entity.Property(e => e.TerminId).HasColumnName("TerminID");
            entity.Property(e => e.Datum).HasColumnType("datetime");
            entity.Property(e => e.KorisnikIdDoktor).HasColumnName("KorisnikID_doktor");
            entity.Property(e => e.KorisnikIdPacijent).HasColumnName("KorisnikID_pacijent");

            entity.HasOne(d => d.KorisnikIdDoktorNavigation).WithMany(p => p.TerminKorisnikIdDoktorNavigations)
                .HasForeignKey(d => d.KorisnikIdDoktor)
                .HasConstraintName("FK_korisnik_termin_doktor");

            entity.HasOne(d => d.KorisnikIdPacijentNavigation).WithMany(p => p.TerminKorisnikIdPacijentNavigations)
                .HasForeignKey(d => d.KorisnikIdPacijent)
                .HasConstraintName("FK_korisnik_termin_pacijent");
        });

        modelBuilder.Entity<TipKorisnika>(entity =>
        {
            entity.HasKey(e => e.TipKorisnikaId).HasName("PK__TipKoris__6CE42F0EC901C725");

            entity.ToTable("TipKorisnika");

            entity.Property(e => e.TipKorisnikaId).HasColumnName("TipKorisnikaID");
            entity.Property(e => e.Tip).HasMaxLength(50);
        });

        modelBuilder.Entity<Transakcija>(entity =>
        {
            entity.HasKey(e => e.TranskcijaId).HasName("PK__Transakc__7403ABDADAAB4592");

            entity.ToTable("Transakcija");

            entity.Property(e => e.NarudzbaId).HasColumnName("NarudzbaID");
            entity.Property(e => e.StatusTransakcije)
                .HasMaxLength(255)
                .IsUnicode(false)
                .HasColumnName("status_transakcije");
            entity.Property(e => e.TransId)
                .HasMaxLength(255)
                .IsUnicode(false)
                .HasColumnName("trans_id");

            entity.HasOne(d => d.Narudzba).WithMany(p => p.Transakcijas)
                .HasForeignKey(d => d.NarudzbaId)
                .HasConstraintName("FK__Transakci__Narud__02FC7413");
        });

        modelBuilder.Entity<VrstaProizvodum>(entity =>
        {
            entity.HasKey(e => e.VrstaId).HasName("PK__VrstaPro__42CB8F0F6304088C");

            entity.Property(e => e.VrstaId).HasColumnName("VrstaID");
            entity.Property(e => e.Naziv).HasMaxLength(50);
        });

        modelBuilder.Entity<ZdravstveniKarton>(entity =>
        {
            entity.HasKey(e => e.ZdravstveniKartonId).HasName("PK__Zdravstv__8A4E4706D0C1A0EA");

            entity.ToTable("ZdravstveniKarton");

            entity.HasIndex(e => e.KorisnikId, "IX_ZdravstveniKarton_KorisnikID");

            entity.Property(e => e.ZdravstveniKartonId).HasColumnName("ZdravstveniKartonID");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.ZdravstveniKartons)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__Zdravstve__Koris__656C112C");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
