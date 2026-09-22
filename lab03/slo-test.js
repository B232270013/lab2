import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 20,
  duration: '1m',
  summaryTrendStats: ['avg', 'min', 'med', 'max', 'p(95)', 'p(99)'],
  thresholds: {
    'http_req_duration{name:cart}': ['p(95)<20'],
    'http_req_failed{name:pay}': ['rate<0.08'],
    checks: ['rate>=0.95'],
    'http_req_duration{name:report}': ['p(95)<450'],
  },
};

export default function () {
  const base = 'http://localhost:3000';

  const c = http.post(`${base}/cart/add`, null, {
    tags: { name: 'cart' },
    timeout: '2s',
  });
  const r = http.get(`${base}/report`, {
    tags: { name: 'report' },
    timeout: '2s',
  });
  const p = http.post(`${base}/pay`, null, {
    tags: { name: 'pay' },
    timeout: '2s',
  });

  check(c, { 'cart 200': (x) => x.status === 200 });
  check(r, { 'report 200': (x) => x.status === 200 });
  check(p, { 'pay 200': (x) => x.status === 200 });

  sleep(1);
}
