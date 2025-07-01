# Terragrunt Infrastructure Management

This repository uses Terragrunt to manage and deploy your Oracle Cloud Infrastructure (OCI) resources. Terragrunt helps keep your Terraform configurations DRY (Don't Repeat Yourself) by centralizing common settings and handling remote state management.

## Project Structure

* **`live/`**: Contains the Terragrunt configurations for deploying your infrastructure.
    * **`live/common.hcl`**: Defines global variables and OCI authentication details shared across all environments.
    * **`live/terragrunt.hcl` (root)**: Configures the remote state backend (OCI Object Storage) and generates the OCI provider block for Terraform, using values from `common.hcl`.
    * **`live/init/`**: This special directory is used to **bootstrap your Terraform state bucket** in OCI Object Storage. You must run this first.
    * **`live/<environment>/`**: Directories for different environments (e.g., `development`, `management`). Each contains `terragrunt.hcl` files for specific components.
* **`modules/`**: Contains reusable Terraform modules that define the actual OCI resources (e.g., `bootstrap`, `drg`, `oci-compartment`).

## Prerequisites

Before you begin, ensure you have the following installed:

* **Git**: For cloning the repository.
* **Terraform**: Your version: `v1.12.2`
* **Terragrunt**: Your version: `0.81.6`
* **OCI CLI**: Installed and configured with your OCI API key and tenancy details.

## Quick Setup Script

A helper script `setup_terragrunt_env.sh` is provided below to assist with the initial setup.

## Configuration Highlights

### `live/common.hcl`

This file centralizes your OCI authentication details and state bucket information.

```hcl
locals {
  customer_name    = "terraform-final"
  bucket_namespace = "idwwlfz5p8th"
  bucket_name      = "terraform-final-terraform-state-file"
  tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaaya43ltpz6zox42qnmodn7mu4lnkwc2cobf6b6yab4lpzltuae5xq"
  user_ocid        = "ocid1.user.oc1..aaaaaaaahdzf2dyy6jkupcqr3bawxntsvvvmqgdev2yuix5zuplmgmpoutkq"
  fingerprint      = "3d:a3:c4:a5:46:fd:92:a6:67:1c:2c:04:34:26:ff:26"
  private_key_path = "/Users/mani/.oci/oci_api_key.pem" # IMPORTANT: Update this path if different
  region           = "us-ashburn-1"
}
```

**Action Required:** Ensure `private_key_path` points to the correct location of your OCI API private key on your machine.

### `live/terragrunt.hcl` (Root Directory)

This file defines how Terragrunt manages the remote state and configures the OCI provider for all child modules. It uses the `generate` block to create `backend.tf` and `provider.tf` files dynamically.

### `live/init/terragrunt.hcl`

This configuration is specifically for creating the OCI Object Storage bucket that will store your Terraform state files. It uses the `bootstrap` module.

## Usage

All Terragrunt commands should be run from within the specific directory of the component you want to manage.

### 1. Initial Setup: Create the State Bucket

This is a **mandatory first step**. You need to create the OCI Object Storage bucket where Terraform will store its state files.

```bash
cd live/init
terragrunt init
terragrunt apply -auto-approve # This will create the state bucket
```

### 2. Deploying Other Modules (Order Matters!)

After the state bucket is created, you can deploy your other infrastructure components. It's crucial to follow a logical order for dependencies. Based on your structure, a common pattern is to deploy foundational components first.

**Suggested Deployment Order:**

1.  **Compartments:** Deploy `compartment-01` in both `development` and `management`.
    ```bash
    cd live/development/compartment-01
    terragrunt init
    terragrunt plan
    terragrunt apply

    cd ../../management/compartment-01
    terragrunt init
    terragrunt plan
    terragrunt apply
    ```

2.  **DRG (Dynamic Routing Gateway):** Deploy the DRG in `management`.
    ```bash
    cd live/management/drg
    terragrunt init
    terragrunt plan
    terragrunt apply
    ```

3.  **Networks:** Deploy `network-02` in both `development` and `management`.
    ```bash
    cd live/development/network-02
    terragrunt init
    terragrunt plan
    terragrunt apply

    cd ../../management/network-02
    terragrunt init
    terragrunt plan
    terragrunt apply
    ```

4.  **DRG Attachment (Development):** Attach the DRG in `development`.
    ```bash
    cd live/development/drg_attachment
    terragrunt init
    terragrunt plan
    terragrunt apply
    ```

5.  **Security Groups:** Deploy `app-sg-03` in `development` and `bastion-sg-03` in `management`.
    ```bash
    cd live/development/app-sg-03
    terragrunt init
    terragrunt plan
    terragrunt apply

    cd ../../management/bastion-sg-03
    terragrunt init
    terragrunt plan
    terragrunt apply
    ```

6.  **Compute Instances:** Deploy `app-04` in `development` and `bastion-compute-04` in `management`.
    ```bash
    cd live/development/app-04
    terragrunt init
    terragrunt plan
    terragrunt apply

    cd ../../management/bastion-compute-04
    terragrunt init
    terragrunt plan
    terragrunt apply
    ```

**General Steps for any module:**

1.  **Navigate to the module directory:**
    ```bash
    cd live/<environment>/<module-name>
    ```
2.  **Initialize Terraform (if needed):**
    ```bash
    terragrunt init
    ```
3.  **Review the plan:**
    ```bash
    terragrunt plan
    ```
4.  **Apply the changes:**
    ```bash
    terragrunt apply
    ```

### Destroying Resources

To destroy resources managed by a specific Terragrunt configuration:

```bash
cd live/<environment>/<module-name>
terragrunt destroy
```

**Use with extreme caution!** To destroy all resources in an environment, you would need to destroy them in reverse order of deployment.

