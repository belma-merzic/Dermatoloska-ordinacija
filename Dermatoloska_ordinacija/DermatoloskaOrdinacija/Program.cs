using DermatoloskaOrdinacija;
using DermatoloskaOrdinacija.Filters;
using DermatoloskaOrdinacija.Model;
using DermatoloskaOrdinacija.Model.SearchObjects;
using DermatoloskaOrdinacija.Services;
using DermatoloskaOrdinacija.Services.Database;
using DermatoloskaOrdinacija.Services.ProizvodiStateMachine;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using RabbitMQ.Client.Events;
using RabbitMQ.Client;
using System.Text;
using System.Text.Json;
using DermatoloskaOrdinacija.Model.Requests;

var builder = WebApplication.CreateBuilder(args);


// Add services to the container.
builder.Services.AddTransient<IProizvodiService, ProizvodiService>();  //Za interface IProizvodiService odgovarajuca implementacija je ProizvodiService
builder.Services.AddTransient<IKorisniciService, KorisniciService>();
builder.Services.AddTransient<INovostiService, NovostiService>();
builder.Services.AddTransient<INarudzbaService, NarudzbaService>();
builder.Services.AddTransient<ITerminService, TerminService>();
builder.Services.AddTransient<IZdravstveniKartonService, ZdravstveniKartonService>();

builder.Services.AddTransient<IService<DermatoloskaOrdinacija.Model.VrstaProizvodum, BaseSearchObject>, BaseService<DermatoloskaOrdinacija.Model.VrstaProizvodum, DermatoloskaOrdinacija.Services.Database.VrstaProizvodum, BaseSearchObject>>();
builder.Services.AddTransient<IDojamService, DojamService>();

builder.Services.AddTransient<IOmiljeniProizvodiService, OmiljeniProizvodiService>();
builder.Services.AddTransient<IRecenzijaService, RecenzijaService>();
builder.Services.AddTransient<ITransakcijaService, TransakcijaService>();

builder.Services.AddTransient<IRecommendResultService, RecommendResultService>();


builder.Services.AddTransient<BaseState>(); 
builder.Services.AddTransient<InitialProductState>(); 
builder.Services.AddTransient<DraftProductState>(); 
builder.Services.AddTransient<ActiveProductState>();


builder.Services.AddHttpContextAccessor();


builder.Services.AddControllers(x => 
{
    x.Filters.Add<ErrorFilter>();
});

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
//builder.Services.AddSwaggerGen();
builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme()
    {
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "basic"
    });

    c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement()
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference{Type = ReferenceType.SecurityScheme, Id = "basicAuth" }
            },
            new string[]{}
        }
    });
});



var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<_200019Context>(options =>
    options.UseSqlServer(connectionString));


builder.Services.AddAutoMapper(typeof(IKorisniciService));



builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);

var app = builder.Build();


// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();



using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<_200019Context>();
    if (!dataContext.Database.CanConnect())
    {
        dataContext.Database.Migrate();

        var recommendResutService = scope.ServiceProvider.GetRequiredService<IRecommendResultService>();
        try
        {
            await recommendResutService.TrainProductsModel();
        }
        catch (Exception e)
        {
        }
    }
}


string hostname = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "rabbitMQ";
string username = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest";
string password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest";
string virtualHost = Environment.GetEnvironmentVariable("RABBITMQ_VIRTUALHOST") ?? "/";



//////////////////////////////////////////////////////////////////////////////////


var factory = new ConnectionFactory 
{
    // HostName = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "rabbitMQ"

    HostName = hostname,
    UserName = username,
    Password = password,
    VirtualHost = virtualHost,
};
using var connection = factory.CreateConnection();
using var channel = connection.CreateModel();

channel.QueueDeclare(queue: "favorites",
                     durable: false,
                     exclusive: false,
                     autoDelete: true,
                     arguments: null);

Console.WriteLine(" [*] Waiting for messages.");

var consumer = new EventingBasicConsumer(channel);
consumer.Received += async (model, ea) =>
{
    var body = ea.Body.ToArray();
    var message = Encoding.UTF8.GetString(body);
    Console.WriteLine(message.ToString());
    var omiljeni = JsonSerializer.Deserialize<OmiljeniProizvodiUpsertRequest>(message);
    using (var scope = app.Services.CreateScope())
    {
        var omiljeniProizvodiService = scope.ServiceProvider.GetRequiredService<IOmiljeniProizvodiService>();

        if (omiljeni != null)
        {
            try
            {
                await omiljeniProizvodiService.Insert(omiljeni);
            }
            catch (Exception e)
            {

            }
        }
    }
    // Console.WriteLine();
    Console.WriteLine(Environment.GetEnvironmentVariable("Some"));
};
channel.BasicConsume(queue: "favorites",
                     autoAck: true,
                     consumer: consumer);


//////////////////////////////////////////////////////////////////////////////////
///


app.Run();
