module.exports = {
  apps: [
    {
      name: "roadsmart-socket-service",
      cwd: "/home/ubuntu/roadsmart-core-stack/roadsmart-socket-service",
      script: "npm",
      args: "start",
      interpreter: "none",
      wait_ready: true,
      listen_timeout: 15000,
    },
  ],
};
