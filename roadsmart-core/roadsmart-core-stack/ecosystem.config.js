module.exports = {
  apps: [
    {
      name: "roadsmart-socket-service",
      cwd: "/home/ubuntu/roadsmart-core-stack/roadsmart-socket-service",
      script: "npm",
      args: "start",
      interpreter: "none",
      wait_ready: true,
      listen_timeout: 5000,
    },
    {
      name: "roadsmart-gateway-5.0",
      cwd: "/home/ubuntu/roadsmart-core-stack/roadsmart-gateway-5.0",
      script: "npm",
      args: "start",
      interpreter: "none",
      wait_ready: true,
      listen_timeout: 5000,
    },
  ],
};
