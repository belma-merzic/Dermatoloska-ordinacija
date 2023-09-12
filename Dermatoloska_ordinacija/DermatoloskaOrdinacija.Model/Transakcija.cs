using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Model
{
    public partial class Transakcija
    {
        public int TranskcijaId { get; set; }

        public int? NarudzbaId { get; set; }

        public double? Iznos { get; set; }

        public string? TransId { get; set; }

        public string? StatusTransakcije { get; set; }
    }
}
