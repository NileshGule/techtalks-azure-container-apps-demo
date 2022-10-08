# Enable Azure Container Apps for subscription

## Sign in to Azure

Follow the prompts and complete the authentication process.

```PowerShell

az login

```

Run the following command to enable Azure Container Apps for your subscription:

Setup Azure CLI extensions

## Install Azure Container Apps extension for the CLI

```powershell

az extension add --name containerapp --upgrade

```

## Register the `Microsoft.App` namespace

```powershell

az provider register --namespace Microsoft.App

```

## Register the `Microsoft.OperationalInsights` provider for the Azure Monitor Log Analytics workspace

```powershell

az provider register --namespace Microsoft.OperationalInsights

```

## References

- [Azure Container Apps - Overview](https://azure.microsoft.com/en-us/products/container-apps/#overview)
- [Azure Container Apps - Getting Started](https://learn.microsoft.com/en-us/azure/container-apps/get-started)
