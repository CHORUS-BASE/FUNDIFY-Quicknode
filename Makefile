# Project variables
CONTRACTS_DIR = ./src
TESTS_DIR = ./test
BUILD_DIR = ./out
DEPLOY_SCRIPT = ./scripts/deploy.s.sol
SOLC_VERSION = 0.8.24
FOUNDRY_PROFILE = default

# Environment variables for deployment
NETWORK = taiko-sepolia # Customize this as needed
ETHERSCAN_API_KEY ?= your_etherscan_api_key
PRIVATE_KEY ?= your_private_key
TAIKO_RPC_URL ?= your_taiko_rpc_url

# Commands
forge := forge
cast := cast

# Targets

# Compile smart contracts
.PHONY: build
build:
	$(forge) build --profile $(FOUNDRY_PROFILE)

# Clean build artifacts
.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)

# Run tests
.PHONY: test
test:
	$(forge) test --profile $(FOUNDRY_PROFILE) -vvv

# Deploy contracts to the Taiko network
.PHONY: deploy
deploy:
	forge script script/Deploy.s.sol:DeployScript --rpc-url $TAIKO_RPC_URL --private-key $PRIVATE_KEY --broadcast --slow -vvvv


# Verify contracts on Taiko-compatible explorer
.PHONY: verify
verify:
	$(forge) verify-contract --etherscan-api-key $(ETHERSCAN_API_KEY) --chain $(NETWORK) $(CONTRACT_ADDRESS) $(CONTRACT_PATH)

# Set environment variables
.PHONY: env
env:
	@echo "Setting environment variables..."
	export PRIVATE_KEY=$(PRIVATE_KEY)
	export ETHERSCAN_API_KEY=$(ETHERSCAN_API_KEY)
	export TAIKO_RPC_URL=$(TAIKO_RPC_URL)

# Run a local node for testing
.PHONY: anvil
anvil:
	anvil

# Start the frontend (if applicable)
.PHONY: frontend
frontend:
	cd frontend && npm start

# Help message
.PHONY: help
help:
	@echo "Fundify Makefile - Commands:"
	@echo "  make build        - Compile the smart contracts"
	@echo "  make clean        - Remove build artifacts"
	@echo "  make test         - Run tests with Foundry"
	@echo "  make deploy       - Deploy contracts to the Taiko network"
	@echo "  make verify       - Verify contracts on Taiko-compatible explorer"
	@echo "  make env          - Set required environment variables"
	@echo "  make anvil        - Run a local Anvil test node"
	@echo "  make frontend     - Start the frontend"
	@echo "  make help         - Display this help message"
