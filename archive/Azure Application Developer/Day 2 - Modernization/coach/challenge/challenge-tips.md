# Challenge overview

# Challenge structure
## Exercise 1
- The first challenge is all about settings things up. Students are not offered any pre-baked Function App code on purpose: it is expected that they are well versed in creating a new Function App in either Visual Studio Code or Visual Studio 2019. 
- As an instructor, you are advised to tell them how to separate their classes representing REST APIs, Orchestrators and Entities. Make sure you explain the differences between the conceptual responsiblities of these and point out that only REST APIs should be accessible externally.
- Don't expect them to write any business logic-code: the "Hello, {name}" sample code is good enough for the first exercise.
- In the real-world, we'd want them to separate the domains physically, meaning that we'd expect them to have multiple projects. This would translate to also having multiple Function Apps running, which would help customers achieve isolation of development, deployment and scalability. However, for this very short challenge scenario, it is recommended that you don't request them to create multiple projects. In fact, suggest them to stay away from that as it might otherwise make the entire debugging experience cumbersome.

## Exercise 2
- For the second challenge, the expectation is that they develop a Durable Entity storing the Product Catalog and the product inventory. Certainly, this would require them to write code for the Inventory API, the Store API.
- Additionally, they're also explicitely asked to create Durable Entities for the ShoppingCart and the Order domains, which means that they would have to write the logic for the ShoppingCart REST API, the Order REST API developed in the first exercise and develop the related entities.
- One important point to make (and this is the whole reason for why the interfaces were designed **NOT** to hold any product data but merely a product identifier in the order and shopping cart interfaces) is that we want the API to return the entire product information in an order/shopping cart, but only want to hold an identifier in the actual corresponding entities. Granted, we'd likely also hold the price for the order entity, but let's just consider those details for now. This is of the essence for the last exercise. Key takeaway: **do not let students change the interfaces. Think of those interfaces as non-negotiable contracts**
- Students will likely be tempted to leverage Cosmos DB. Congratulate them for doing so, especially if they used **function bindings**. However, that's beyond the purpose of this exercise. In fact, feel free to showcase the pros and cons of using Cosmos DB (or any other data retation service) for such a simple example: cost (keep in mind that Cosmos DB also has a free tier, though), transactional support, higher SLA.

## Exercise 3
- Here's where things get tricky and go beyond the 'Hello, world' samples. We want students to learn and try to orchestrate calls among entites and orchestrator and entities.
- For the ShopingCart orchestrator, we want them to retrieve a user's shopping cart from an entity, enrich the result with product information and return it in a single call back to the calling client function.
- For the Order orchestrator, we want users to have a transaction within which they pull the shopping cart products from stock, create the order and delete the shopping cart. If an item isn't on stock, the operation should fail.

# Things to remember
## General tips
- **PLEASE, do not offer the solution to your students**. 
This is a challenge environment, meaning that they are supposed to come up with a solution by themselves. Offering a different solution than the one suggested in this guide is perfectly fine, as long as it meets the requirements, is serverless and adheres to the scenario.
- Keep in mind that students can go through all the challenge instructions without actually developing anything. Therefore, you won't have to mark their solution as completed, but are advised to interract with them and validate their assumptions/solutions.
- As much as possible, emphasize with your strudents that you want them to take advantage of Durable Functions, Durable Entities etc. Using transactions is of the essence.
- It is understandable that they might argue that CosmosDB or Azure SQL Database might solve the same problem too. And they are right - as the proverb says, '*There's more than one way to skin a cat*'. The emphasis of this challenge is to bring to light the capabilities and design pattern of durable entities
## Proposed solution insights
- If you are planning on working on the proposed solution yourself (which is highly recommended), please know that students will receive a .NET Standard 2.0 project containing the interfaces they're supposed to implement. In the suggested solution, the implementation is in .NET Core 3.1, targetting Azure Functions 3.0
- When you attempt to run the function locally, you will miss a local environment settings file, local.settings.json. In Azure Functions, this file holds application settings, strings etc. In an Azure environment, this would equivalate to the *App Settings* of the App Service (the Function App).
Feel free to use this snippet as a starting point for your own local.settings.json. The file should be located in the root of the **project** folder (ECommerce).

``` C#
{
    "IsEncrypted": false,
    "Values": {
        "AzureWebJobsStorage": "<STORAGE_ACCOUNT_CONNECTION_STRING>",
        "FUNCTIONS_WORKER_RUNTIME": "dotnet"
    }
}
```

- The proposed solution might have missing implementations of functions, but that's perfectly fine considering that all desired scenarios all implemented. (at the time of this writing, *OrderGet* wasn't implemented as it would only use the same function concept as ). The key pieces are in fact the Entity and Orchestrator implemetations.
- The proposed solution showcases the idea of:
    * a singleton statefull entity which holds the product catalog and inventory. Any other service, any other domain and any other actor would ever require information about the current inventory would reach out to this one instance and retrieve the data.
    * an entity which is contextual for every user. A user might have multiple orders, so adding an order to a user makes sense. Every order will contain a variable number of items he/she bought
    * an entity which, similar to the order entity, is contextual per user. However, the shopping cart should be short-lived.
    * an orchestrator which combines call from multiple entities together. In the proposed solution, because an item in the shopping cart is represented as an identifier only (part of the list of items in the shopping cart), when a user requests via an API call the shopping cart, the orchestrator ought to retrieve the shopping cart information form one entity and the correlated product information from another entity. To improve efficiency, this can be parallelized, as shown in the proposed solution by using asynchronous tasks.
    * an orchestrator which follows a business logic calling out multiple entities and wrapping all operations within transactions. Specifically, the inventory should decrease as the order gets created. Once the order was successfully created, the shopping cart should be purged. If neither of the conditions were met (e.g. items available on stock), the entire operation should fail. The *Chechout* operation is cannonically understood as an atomic operation, hence the reason for why we want students to know about this capability.

## In case they students finish early
- Ask them to show you how they would separate the project to multiple projects. In fact, this would have been the next exercise. In any typical microservices-based scenario, once the domains were determined, each domain would be independent and isolated from other domains. This implies that a Function app represents a single domain. In the proposed solution and the solution students likely developed, they created a single project which in turn will get deployed into a single Function App, even though the project covers multiple domains.

**NOTE** that the reason behind physcal domain separation into multiple function apps is to achieve isolation of development, deployment and scalability. Had students started the challenge by creating multiple projects, chances for them to finish on time would have been greatly minimized due to the undesirable debugging experience.

- Additionally, you should also ask your students to load-test the Function using a Consumption plan and later, using a Premium Plan. If they've set Application Insights up, they should be able to determine where the bottle necks are and how the user experience would look like: this itself would be an indication of which services should be scaled out separately and whether or not caches, CDNs or external services are required (and when/at what point of the application maturity)