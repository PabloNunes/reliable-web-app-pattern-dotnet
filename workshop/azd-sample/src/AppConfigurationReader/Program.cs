using ReleCloudLite.Web.Data;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.Extensions.Configuration;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorPages();
builder.Services.AddServerSideBlazor();
builder.Services.AddSingleton<WeatherForecastService>();
builder.Services.AddSingleton<TicketService>();

string appConfigUrl = builder.Configuration["AzureUrls:AppConfiguration"]!;

// add app configuration
//builder.Configuration.AddAzureAppConfiguration(options =>
//{
//    options.Connect(appConfigUrl);
//});

builder.Services.AddHttpClient<TicketService>(client =>
{
    client.BaseAddress = new Uri("https://localhost:7171/");
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();

app.UseStaticFiles();

app.UseRouting();

app.MapBlazorHub();
app.MapFallbackToPage("/_Host");

app.Run();