using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Model.Requests
{
    public class TransakcijaUpsertRequest
    {
        public int? NarudzbaId { get; set; }

        public double? Iznos { get; set; }
        public string? TransId { get; set; }

        public string? StatusTransakcije { get; set; }
    }
}
