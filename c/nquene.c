#include <stdio.h>
int t(int a, int b, int c) {
  int f = 1;
  if (a) {
    int d, e = a & ~b & ~c;
    f = 0;
    while ((d = e & -e)) {
      f += t(a - d, (b + d) * 2, (c + d) / 2);
      e -= d;
    }
  }
  return f;
}
int main() {
  int n;
  scanf("%d", &n);
  printf("q(%d) = %d\n", n, t(~(~0 << n), 0, 0));
}
