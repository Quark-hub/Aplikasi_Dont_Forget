package org.qtproject.example;

import android.app.AlarmManager;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import androidx.core.app.NotificationCompat;

public class AlarmReceiver extends BroadcastReceiver {
    private static final String CHANNEL_ID = "focusflow_channel";

    @Override
    public void onReceive(Context context, Intent intent) {
        String action = intent.getAction();
        int id = intent.getIntExtra("id", 0);
        String title = intent.getStringExtra("title");
        String message = intent.getStringExtra("message");
        String tanggal = intent.getStringExtra("tanggal");
        String waktu = intent.getStringExtra("waktu");

        AlarmManager alarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
        NotificationManager manager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

        // JIKA TOMBOL SNOOZE DITEKAN
        if ("ACTION_SNOOZE".equals(action)) {
            long snoozeTime = System.currentTimeMillis() + (10 * 60 * 1000); // 10 Menit

            Intent snoozeIntent = new Intent(context, AlarmReceiver.class);
            snoozeIntent.putExtra("id", id);
            snoozeIntent.putExtra("title", title);
            snoozeIntent.putExtra("message", message);

            PendingIntent pendingIntent = PendingIntent.getBroadcast(context, id, snoozeIntent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, snoozeTime, pendingIntent);
            } else {
                alarmManager.setExact(AlarmManager.RTC_WAKEUP, snoozeTime, pendingIntent);
            }
            manager.cancel(id); // Tutup notif lama
            return;
        }

        // JIKA ALARM NORMAL BERBUNYI
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, "Pengingat Tugas", NotificationManager.IMPORTANCE_HIGH);
            manager.createNotificationChannel(channel);
        }

        Intent snoozeIntent = new Intent(context, AlarmReceiver.class);
        snoozeIntent.setAction("ACTION_SNOOZE");
        snoozeIntent.putExtra("id", id);
        snoozeIntent.putExtra("title", title);
        snoozeIntent.putExtra("message", message);
        PendingIntent snoozePendingIntent = PendingIntent.getBroadcast(context, id + 1000, snoozeIntent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);

        Intent openIntent =
                context.getPackageManager()
                       .getLaunchIntentForPackage(
                           context.getPackageName()
                       );

        openIntent.putExtra(
                "targetPage",
                "Checklist"
        );

        PendingIntent openPendingIntent =
                PendingIntent.getActivity(
                    context,
                    0,
                    openIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT
                    | PendingIntent.FLAG_IMMUTABLE
                );

        NotificationCompat.Builder builder =
            new NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(android.R.drawable.ic_dialog_info)
                .setContentTitle(title)
                .setContentText("📅 " + tanggal + " | 🕒 " + waktu)
                .setStyle(
                    new NotificationCompat.BigTextStyle()
                        .bigText(
                            "📅 Tanggal : " + tanggal + "\n" +
                            "🕒 Waktu   : " + waktu + "\n\n" +
                            "📝 Catatan :\n" + message
                        )
                )
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setAutoCancel(true)
                .setContentIntent(openPendingIntent);

        manager.notify(id, builder.build());
    }
}