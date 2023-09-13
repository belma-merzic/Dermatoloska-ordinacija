using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace DermatoloskaOrdinacija.Services.Database;

public partial class RecommendResult
{
    public int Id { get; set; }

    public int? ProizvodId { get; set; }

    public int? PrviProizvodId { get; set; }

    public int? DrugiProizvodId { get; set; }

    public int? TreciProizvodId { get; set; }
}
