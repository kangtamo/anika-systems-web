#r "Newtonsoft.Json"
#r "SendGrid"

using System.Net;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Primitives;
using Newtonsoft.Json;
using SendGrid.Helpers.Mail;

public static SendGridMessage Run(Contact req, ICollector<Contact> tableBinding, ILogger log)
{
    // add Contact object to tableBinding. This will insert all of the Contact Form fields into azure tables
    tableBinding.Add(
        new Contact() { 
            PartitionKey = "ContactForm", 
            RowKey = Guid.NewGuid().ToString(), 
            Name = req.Name,
            Phone = req.Phone,
            Email = req.Email,
            Subject = req.Subject,
            Message = req.Message }
        );
        
    // sendgrid integration. new email message populated with Contact Form fields
    SendGridMessage message = new SendGridMessage()
    {
        Subject = $"ContactAnikaSystemsForm Subject: {req.Subject}"
    };
    
    message.AddContent("text/plain", $"Subject: {req.Subject} \n \n" + $"Message: {req.Message} \n \n" + $"From: {req.Name} \n \n" + $"Phone:{req.Phone} \n \n" + $"Email: {req.Email} ");
    
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
