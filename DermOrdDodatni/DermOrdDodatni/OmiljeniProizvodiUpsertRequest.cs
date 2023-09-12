namespace DermOrdDodatni
{
    public class OmiljeniProizvodiUpsertRequest
    {
        public DateTime? DatumDodavanja { get; set; }

        public int? ProizvodId { get; set; }

        public int? KorisnikId { get; set; }
    }
}
