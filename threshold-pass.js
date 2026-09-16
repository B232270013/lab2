import http from 'k6/http';
import { check, sleep } from 'k6';

const sloP95 = Number(__ENV.SLO_P95_MS);

if (!Number.isFinite(sloP95) || sloP95 <= 0) {
  throw new Error(
    'SLO_P95_MS is required. Example: k6 run -e SLO_P95_MS=120 threshold-pass.js'
  );
}

export const options = {
  vus: 30,
  duration: '1m',
  thresholds: {
    http_req_duration: [`p(95)<${sloP95}`],
    http_req_failed: ['rate<0.01'],
  },
};

export default function () {
  const res = http.get('https://test.k6.io');

  check(res, {
    'status 200 байна': (r) => r.status === 200,
  });

  sleep(1);
}
