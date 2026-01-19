module.exports = {
  apps: [
    {
      name: "roadsmart-socket-service",
      cwd: "/home/ubuntu/roadsmart-core-stack/roadsmart-socket-service",
      script: "./deploy.sh",
      interpreter: "script",
      wait_ready: true,
      listen_timeout: 5000,
    },
    {
      name: "roadsmart-gateway-5.0",
      cwd: "/home/ubuntu/roadsmart-core-stack/roadsmart-gateway-5.0",
      script: "./deploy.sh",
      interpreter: "script",
      wait_ready: true,
      listen_timeout: 5000,
    },
    {
      name: "roadsmart-gateway-5.0.1",
      cwd: "/home/ubuntu/roadsmart-core-stack/roadsmart-gateway-5.0.1",
      script: "./deploy.sh",
      interpreter: "script",
      wait_ready: true,
      listen_timeout: 5000,
    },
    {
      name: "roadsmart-croncomm-service",
      cwd: "/home/ubuntu/roadsmart-core-stack/roadsmart-croncomm-service",
      script: "./deploy.sh",
      interpreter: "bash",
      wait_ready: true,
      listen_timeout: 5000,
    },
    {
      name: "roadsmart-web-platform",
      cwd: "/home/ubuntu/roadsmart-core-stack/roadsmart-web-platform",
      script: "./deploy.sh",
      interpreter: "bash",
      wait_ready: true,
      listen_timeout: 5000,
    },
  ],
};
