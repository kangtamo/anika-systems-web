#r "Newtonsoft.Json"
#r "SendGrid"

using System.Net;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Primitives;
using Newtonsoft.Json;
using SendGrid.Helpers.Mail;


public static async Task<SendGridMessage> Run(HttpRequest req, ICollector<Contact> tableBinding, ILogger log)
{
    
    log.LogInformation("C# HTTP trigger function processed a request.");

    string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
    dynamic data = JsonConvert.DeserializeObject(requestBody);

    SendGridMessage message = new SendGridMessage()
    {
        Subject = $"ContactAnikaSystemsForm Subject: {data[0].value}"
    };

    message.AddContent("text/plain", $"Subject: {data[0].value} \n \n" + $"Message: {data[4].value} \n \n" + $"From: {data[2].value} \n \n" + $"Phone: {data[1].value} \n \n" + $"Email: {data[3].value} ");
    
    tableBinding.Add(
        new Contact() {
            PartitionKey = "ContactForm",
            RowKey = Guid.NewGuid().ToString(), 
            Name = data[2].value,
            Phone = data[1].value,
            Email = data[3].value,
            Subject = data[0].value,
            Message = data[4].value }
    );
    return message;
}

public class Contact
{
    public string Content { get; set; }
    public string Name { get; set; }
    public string Phone { get; set; }
    public string Email { get; set; }
    public string Subject { get; set; }
    public string Message { get; set; }
    public string PartitionKey { get; set; } 
    public string RowKey { get; set; }
    
}



